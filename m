Return-Path: <linux-kernel-owner+w=401wt.eu-S1762906AbXH3Vou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762906AbXH3Vou (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 17:44:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756144AbXH3Vom
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 17:44:42 -0400
Received: from mail.fieldses.org ([66.93.2.214]:57907 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754269AbXH3Vol (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 17:44:41 -0400
Date: Thu, 30 Aug 2007 17:44:31 -0400
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: NFS4 authentification / fsuid
Message-ID: <20070830214431.GF10808@fieldses.org>
References: <Pine.LNX.4.64.0708301610290.24730@fbirervta.pbzchgretzou.qr> <1188484155.6755.38.camel@heimdal.trondhjem.org> <1188484337.6755.41.camel@heimdal.trondhjem.org> <Pine.LNX.4.64.0708301640030.24730@fbirervta.pbzchgretzou.qr> <1188486240.6755.51.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1188486240.6755.51.camel@heimdal.trondhjem.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2007 at 11:04:00AM -0400, Trond Myklebust wrote:
> With CIFS or other password based protocols (including RPCSEC_GSS)

Well, rpcsec_gss isn't inherently password based, and you can
authenticate in some way that doesn't actually give away your password
(or other long-lived credential).

> What I'm saying is that the superuser can pretty much do whatever it
> takes to grab either your kerberos password (e.g. install a keyboard
> listener), a stored credential (read the contents of your kerberos
> on-disk credential cache), or s/he can access the cached contents of the
> file by hunting through /dev/kmem.
> 
> IOW: There is no such thing as security on a root-compromised machine.

And in theory a kernel could provide *some* guarantees against root,
right?  (Is there some reason a unix-like kernel must provide such
things as /dev/kmem?)

--b.
