Return-Path: <linux-kernel-owner+w=401wt.eu-S932113AbXBENJH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113AbXBENJH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 08:09:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932333AbXBENJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 08:09:06 -0500
Received: from moutng.kundenserver.de ([212.227.126.177]:51094 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932113AbXBENJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 08:09:05 -0500
Date: Mon, 5 Feb 2007 14:08:51 +0100 (CET)
From: Bodo Eggert <7eggert@gmx.de>
To: Alan <alan@lxorguk.ukuu.org.uk>
cc: Bodo Eggert <7eggert@gmx.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, Andrew Morton <akpm@osdl.org>,
       Jon Masters <jonathan@jonmasters.org>,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH/RFC] alternative aproach to: Ban module license tag string
 termination trick
In-Reply-To: <20070203200209.4f931fdc@localhost.localdomain>
Message-ID: <Pine.LNX.4.58.0702051342210.3110@be1.lrz>
References: <Pine.LNX.4.58.0702022216120.25199@be1.lrz>
 <20070203200209.4f931fdc@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:9b3b2cc444a07783f194c895a09f1de9
X-Provags-ID2: V01U2FsdGVkX19/mj6BFoLZxiFUfvIisDl0Z3Uyzg1Kc1omGLk/YVDwrG4QAk3TOP3qhQCaijXwi6aWptP8Wolab2Dp2FtGdBFb/eL6x9203xZeXIc47p1eDg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Feb 2007, Alan wrote:
> Bodo Eggert <7eggert@gmx.de> wrote:

> > This patch changes the module license handling code to:
> > - allow modules to have multiple licenses
> 
> NAK

I still think it would be a good idea, but if too many people misinterpret 
my concept, you can't do that.

> > - access GPL symbols if at least one license is GPL-compatible
> 
> NAK
> 
> The legal boundary of a work is not "the file".

IMO, the scope of the MODULE_LICENSE is the module. If you intend to ship 
one binary using _only_ the proprietary license, you'll have to remove the 
license=GPL-string. Obviously this isn't obvious. :(

-- 
Backups? We doan NEED no steenking baX%^~,VbKx NO CARRIER 
