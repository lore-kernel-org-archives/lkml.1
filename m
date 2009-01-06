Return-Path: <linux-kernel-owner+w=401wt.eu-S1753448AbZAFOdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448AbZAFOdo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 09:33:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752029AbZAFOde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 09:33:34 -0500
Received: from relay3.sgi.com ([192.48.171.31]:35335 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751844AbZAFOde (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 09:33:34 -0500
Date: Tue, 6 Jan 2009 08:33:30 -0600
From: Jack Steiner <steiner@sgi.com>
To: Nick Piggin <npiggin@suse.de>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, Cliff Wickman <cpw@sgi.com>,
       Russ Anderson <rja@sgi.com>
Subject: Re: [patch] x86: make UV support optional
Message-ID: <20090106143330.GB18913@sgi.com>
References: <20090106060348.GA16738@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090106060348.GA16738@wotan.suse.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2009 at 07:03:48AM +0100, Nick Piggin wrote:
> UV is fairly rare.... and much of the support is already there to cope with
> 32-bit builds. So this makes sense I think.
>


Looks ok to me. One suggestion though. There is a MAXSMP config
option. I would suggest enabling UV if MAXSMP is enabled. This
will help ensure that UV is tested more frequently & may minimize
regressions.


--- jack
