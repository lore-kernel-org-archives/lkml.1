Return-Path: <linux-kernel-owner+w=401wt.eu-S1754786AbXLGAYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786AbXLGAYc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 19:24:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752612AbXLGAYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 19:24:24 -0500
Received: from fmailhost05.isp.att.net ([207.115.11.55]:60959 "EHLO
	fmailhost05.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473AbXLGAYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 19:24:24 -0500
X-Originating-IP: [74.227.37.72]
Date: Thu, 6 Dec 2007 18:24:21 -0600
From: Jay Cliburn <jacliburn@bellsouth.net>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: sam@ravnborg.org, linux-kernel@vger.kernel.org
Subject: Re: Allow (O=...) from file
Message-ID: <20071206182421.5d2bd0bd@osprey.hogchain.net>
In-Reply-To: <Pine.LNX.4.64.0712061556350.19266@fbirervta.pbzchgretzou.qr>
References: <20071204210433.4d7ee66c@osprey.hogchain.net>
	<Pine.LNX.4.64.0712061556350.19266@fbirervta.pbzchgretzou.qr>
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Dec 2007 15:57:38 +0100 (CET)
Jan Engelhardt <jengelh@computergmbh.de> wrote:

> 
> On Dec 4 2007 21:04, Jay Cliburn wrote:
> >
> >This piece of the top-level Makefile in current git causes an
> >out-of-tree driver Makefile to fail.
> >
> >101 ifdef O
> >102   ifeq ("$(origin O)", "command line")
> >103     KBUILD_OUTPUT := $(O)
> >104   endif
> >105 endif
> 
> Should not it just use the usual boilerplate?
> 
> kdir := /lib/modules/$(shell uname -r)/build
> all:
> 	make -C ${kdir} M=$$PWD

Yep, that certainly works, but I was using a vendor-provided Makefile
that employs O=...
