Return-Path: <linux-kernel-owner+w=401wt.eu-S1755209AbYCaCNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209AbYCaCNV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 22:13:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751358AbYCaCNM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 22:13:12 -0400
Received: from de01egw01.freescale.net ([192.88.165.102]:55123 "EHLO
	de01egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735AbYCaCNL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 22:13:11 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] fix the broken annotations in fsldma
Date: Mon, 31 Mar 2008 10:12:58 +0800
Message-ID: <78567AC4946EDC42B7DE978C350CD869EEBC96@zch01exm26.fsl.freescale.net>
In-Reply-To: <20080329183828.GD9785@ZenIV.linux.org.uk>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] fix the broken annotations in fsldma
Thread-Index: AciRzBpSegV/6BM+SXSwmJv1zT6LvQBCDhpg
References: <E1JfRSU-0002xg-LA@ZenIV.linux.org.uk> <1206799322.12155.10.camel@vader.jdub.homelinux.org> <20080329183828.GD9785@ZenIV.linux.org.uk>
From: "Zhang Wei" <Wei.Zhang@freescale.com>
To: "Al Viro" <viro@ZenIV.linux.org.uk>, "Josh Boyer" <jwboyer@gmail.com>
Cc: "Al Viro" <viro@ftp.linux.org.uk>, <torvalds@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 

> -----Original Message-----
> From: Al Viro [mailto:viro@ftp.linux.org.uk] On Behalf Of Al Viro
> 
> On Sat, Mar 29, 2008 at 09:02:02AM -0500, Josh Boyer wrote:
> > On Sat, 2008-03-29 at 03:10 +0000, Al Viro wrote:
> > > a) every bitwise declaration will give a unique type; use 
> typedefs.
> > > b) no need to bother with the stuff pointed to by iomem 
> pointers, unless
> > > it's accessed directly.  noderef will force us to use 
> helpers anyway.
> 
> > Did you forget to do the s/u{32,64}/v{32,64}/ conversion for this
> > struct, or am I just a moron?
> 
> See (b) above.
> 

Do you mean if we do it with a known 'force' casting, we do not need the
compiler check's help?

Thanks!
Wei.
