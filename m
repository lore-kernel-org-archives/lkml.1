Return-Path: <linux-kernel-owner+w=401wt.eu-S969450AbXILOcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969450AbXILOcd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 10:32:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966942AbXILOcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 10:32:25 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48783 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966768AbXILOcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 10:32:24 -0400
Date: Wed, 12 Sep 2007 16:32:23 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Andi Kleen <andi@firstfloor.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] Scheduler Profiling - Use Immediate Values
Message-ID: <20070912143223.GB2287@one.firstfloor.org>
References: <20070906200537.GA5999@Krystal> <p73bqcd9lw4.fsf@bingen.suse.de> <20070912141947.GA7313@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070912141947.GA7313@Krystal>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The idea is not to hide the unlikely, but to leave the opportunity to
> make this primitive evolve in something that won't depend on a load
> immediate and only require patching of a jump, given the appropriate gcc
> support (yet to come).

If that ever happens the code can be still changed. But i don't think
it's a good idea to uglify the code for something that if it 
ever exists will be a long time away.

Besides if gcc supports it I assume the gcc support could 
also be written in a way that makes it possible to hide it inside
a standard if ()

-Andi
