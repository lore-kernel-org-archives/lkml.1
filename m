Return-Path: <linux-kernel-owner+w=401wt.eu-S1753175AbXBKKmH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175AbXBKKmH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 05:42:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753174AbXBKKmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 05:42:07 -0500
Received: from mx2.suse.de ([195.135.220.15]:37943 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753172AbXBKKmG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 05:42:06 -0500
From: Andi Kleen <ak@suse.de>
To: Christopher Li <sparse@chrisli.org>
Subject: Re: [ANNOUNCE] sparse-0.2-cl2 is now available
Date: Sun, 11 Feb 2007 11:41:54 +0100
User-Agent: KMail/1.9.5
Cc: Al Viro <viro@ftp.linux.org.uk>, linux-sparse@vger.kernel.org,
       linux kernel mail list <linux-kernel@vger.kernel.org>,
       Josh Triplett <josh@freedesktop.org>
References: <20070204085329.GA6520@chrisli.org> <20070211055015.GR10050@ftp.linux.org.uk> <20070211060255.GA2312@chrisli.org>
In-Reply-To: <20070211060255.GA2312@chrisli.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702111141.54900.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> If we keep it 10 times over head, my home computer can load the full linux
> kernel and have some spare for checking.
> 
> I am still working on the bytecode loader and linker for merging symbols.
> It need to answer the question:
> 
> Which file define which function.
> Which external symbol does this function use.
> 
> Once we get the function user/define chain, it can enable a lot of new checking.

At least for interrupts on/off you'll likely need new annotations because
this state can be changed in assembly files before/after calling out to 
C.

For locks this fortunately cannot happen (at least not on x86*) 

-Andi

