Return-Path: <linux-kernel-owner+w=401wt.eu-S1758223AbXIFPLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758223AbXIFPLb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 11:11:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756627AbXIFPLZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 11:11:25 -0400
Received: from mail.fieldses.org ([66.93.2.214]:46726 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753750AbXIFPLY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 11:11:24 -0400
Date: Thu, 6 Sep 2007 11:11:18 -0400
To: Satyam Sharma <satyam@infradead.org>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: NFS4 authentification / fsuid
Message-ID: <20070906151118.GB28565@fieldses.org>
References: <Pine.LNX.4.64.0708301610290.24730@fbirervta.pbzchgretzou.qr> <1188484155.6755.38.camel@heimdal.trondhjem.org> <1188484337.6755.41.camel@heimdal.trondhjem.org> <Pine.LNX.4.64.0708301640030.24730@fbirervta.pbzchgretzou.qr> <1188486240.6755.51.camel@heimdal.trondhjem.org> <20070830214431.GF10808@fieldses.org> <alpine.LFD.0.999.0709061333410.3781@enigma.security.iitk.ac.in> <alpine.LFD.0.999.0709061355350.3781@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0709061355350.3781@enigma.security.iitk.ac.in>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2007 at 01:59:50PM +0530, Satyam Sharma wrote:
> Oh and btw, note that we're talking of the (lack of) security of a
> "running kernel" here -- because across reboots, there is /really/
> *absolutely* no such thing as "kernelspace security" because the superuser
> will simply switch the vmlinuz itself ...

Well, the machine could be booting from cdrom, and could live in a
locked machine room.  Or people with root on a virtual host don't
necessarily have the ability to replace the kernel for that host.

--b.
