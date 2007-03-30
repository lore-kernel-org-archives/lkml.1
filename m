Return-Path: <linux-kernel-owner+w=401wt.eu-S1753832AbXC3VDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832AbXC3VDu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 17:03:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753920AbXC3VDu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 17:03:50 -0400
Received: from mail.fieldses.org ([66.93.2.214]:48810 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753832AbXC3VDt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 17:03:49 -0400
Date: Fri, 30 Mar 2007 17:03:44 -0400
To: Thorsten Kranzkowski <dl8bcu@dl8bcu.de>, nfs@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: Odd log message associated with NFS
Message-ID: <20070330210344.GF15224@fieldses.org>
References: <2fe399760703271140l703c2791oa84e9e1832487dcb@mail.gmail.com> <20070327193909.GA585@ds20.borg.net> <20070328165925.GB21221@fieldses.org> <20070328190536.GB585@ds20.borg.net> <20070328232348.GJ21221@fieldses.org> <20070330205145.GA1349@Marvin.DL8BCU.ampr.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070330205145.GA1349@Marvin.DL8BCU.ampr.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2007 at 08:51:45PM +0000, Thorsten Kranzkowski wrote:
> The source address obviously isn't from my local net, and the clear
> text speaks for itself.

Woah, yeah, neato.  OK, I guess that makes me a lot more willing to
believe any "impossible" error in linux/net/sunrpc/svc.c:svc_process()
is due to random garbage on the network.

I'd definitely like more people to be able to run their nfs server
outside any firewall, so that probably means we should demote these
printk's to dprintk's some day.

> looks like an attack to some Windows service with phishing content.
> luckily this machine is neither windows based nor intel compatible :)

I'd love to know what the heck it's actually trying to do.

Thanks for the followup!

--b.
