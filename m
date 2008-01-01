Return-Path: <linux-kernel-owner+w=401wt.eu-S1753664AbYAADpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664AbYAADpj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 22:45:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750829AbYAADpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 22:45:33 -0500
Received: from moutng.kundenserver.de ([212.227.126.177]:60060 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797AbYAADpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 22:45:31 -0500
Date: Tue, 1 Jan 2008 04:45:21 +0100 (CET)
From: Bodo Eggert <7eggert@gmx.de>
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: Bodo Eggert <7eggert@gmx.de>, David Miller <davem@davemloft.net>,
       jengelh@computergmbh.de, devzero@web.de, linux-kernel@vger.kernel.org,
       bunk@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] Force UNIX domain sockets to be built in
In-Reply-To: <20071231193848.GQ27894@ZenIV.linux.org.uk>
Message-ID: <alpine.LSU.0.999.0801010418260.2337@be1.lrz>
References: <alpine.LSU.0.999.0712311300020.3686@be1.lrz>
 <20071231.042055.145660385.davem@davemloft.net> <alpine.LSU.0.999.0712311426520.3761@be1.lrz>
 <20071231193848.GQ27894@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX18cUF1cobpauD0HhRYwgMNxCSLsooMCQcP7p3m
 vhXu7dfQfyWQMXXWFaj2DRFDaqkngslHst8ifu+82YsxR06O98
 1akDunaTr7ByvRMVEZt+g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Dec 2007, Al Viro wrote:
> On Mon, Dec 31, 2007 at 03:03:20PM +0100, Bodo Eggert wrote:
> > On Mon, 31 Dec 2007, David Miller wrote:
> > > From: Bodo Eggert <7eggert@gmx.de>

> > > > As suggested by Adrian Bunk, UNIX domain sockets should always be built in 
> > > > on normal systems. This is especially true since udev needs these sockets
> > > > and fails to run if UNIX=m.
> > > > 
> > > > Signed-Off-By: Bodo Eggert <7eggert@gmx.de>
> > > 
> > > People who use udev can make sure they have it built into their kernel
> > > if they have such a dependency.
> > > 
> > > Not everyone uses udev, and therefore needs AF_UNIX non-modular.
> > 
> > That's why I kept this option for embedded folks.
> > 
> > Is there any benefit for non-embedded systems from having UNIX=m?
> 
> udev-free != embedded.

But UNIX=m == waste RAM and have an effectively b0rken system until the 
module is loaded. It would be silly to do this unless you have a very small 
space for the kernel image and some free space for storing the needed 
modules. The big question is: Is there any non-embedded system where you 
have to aim for a small kernel image?

-- 
Fun things to slip into your budget
Half a million dollars for consultants to design a web site that was being
done by an intern in his spare time.
