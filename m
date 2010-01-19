Return-Path: <linux-kernel-owner+w=401wt.eu-S1754791Ab0ASRIN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791Ab0ASRIN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 12:08:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754711Ab0ASRIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 12:08:09 -0500
Received: from eddie.linux-mips.org ([78.24.191.182]:52691 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754770Ab0ASRII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 12:08:08 -0500
Date: Tue, 19 Jan 2010 17:56:39 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: what's up with "make -j N" output?
Message-ID: <20100119165639.GC23161@linux-mips.org>
References: <20100118202414.GA4207@x200>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100118202414.GA4207@x200>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 18, 2010 at 10:24:14PM +0200, Alexey Dobriyan wrote:

> Script does effectively:
> 
> 	make -k -j5 &>1.log

My automated builds effectively run a number of "make -j 1" builds in
parallel so I get sane parsable and readable logs.  I don't think we
give any guarantees for -j 2 or higher even though that would be highly
desirable when things go wrong.

  Ralf
