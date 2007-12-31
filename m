Return-Path: <linux-kernel-owner+w=401wt.eu-S1759466AbXLaN1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759466AbXLaN1U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 08:27:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752778AbXLaN1H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 08:27:07 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:55151 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739AbXLaN1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 08:27:06 -0500
Date: Mon, 31 Dec 2007 14:26:42 +0100 (CET)
From: Bodo Eggert <7eggert@gmx.de>
To: Adrian Bunk <bunk@kernel.org>
cc: Bodo Eggert <7eggert@gmx.de>, Jan Engelhardt <jengelh@computergmbh.de>,
       devzero@web.de, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] Force UNIX domain sockets to be built in
In-Reply-To: <20071231122419.GA13803@does.not.exist>
Message-ID: <alpine.LSU.0.999.0712311335210.3761@be1.lrz>
References: <alpine.LSU.0.999.0712311300020.3686@be1.lrz>
 <20071231122419.GA13803@does.not.exist>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX19Bu3YrHWMYxy97BqnYZ9FhR+aN4ZIHMcW3OhZ
 82RAVj5xjNaDWq9QoyB1sXPdtWijSKUqxdl5fqkM5GUtCxfwAX
 sOMzmfCiKEUD+TPo3ho1w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Dec 2007, Adrian Bunk wrote:
> On Mon, Dec 31, 2007 at 01:09:43PM +0100, Bodo Eggert wrote:

> > As suggested by Adrian Bunk, UNIX domain sockets should always be built in 
> > on normal systems. This is especially true since udev needs these sockets
> > and fails to run if UNIX=m.
> > 
> > Signed-Off-By: Bodo Eggert <7eggert@gmx.de>
> > 
> > ---
> > Last minute change: I decided against making it a bool because embedded 
> > folks might depend on a small kernel image. Edited in the patch below.
> >...
> 
> Is this just a purely theoretical thought or is this a reasonable use 
> case people actually use in practice?
 
For now, it's a theoretical thought, but having an embedded device, I can 
see the reason for $EVERYTHING=m there.

> After all, changing it to a bool will allow us to make the kernel image 
> for nearly everyone smaller by a few hundred bytes...

I can't see why optionally building it as a module would force us to make 
the kernel bigger. It may be a little more ugly to support =m, but thats it,
isn't it?

-- 
Logic: The art of being wrong with confidence...
