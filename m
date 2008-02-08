Return-Path: <linux-kernel-owner+w=401wt.eu-S1758150AbYBHXhA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758150AbYBHXhA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 18:37:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756409AbYBHXgp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 18:36:45 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:44535 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755270AbYBHXgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 18:36:44 -0500
Date: Sat, 9 Feb 2008 01:36:39 +0200 (EET)
From: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
X-X-Sender: ijjarvin@kivilampi-30.cs.helsinki.fi
To: Jan Engelhardt <jengelh@computergmbh.de>
cc: ael <law_ence.dev@ntlworld.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: git tree urls
In-Reply-To: <Pine.LNX.4.64.0802082353390.26116@fbirervta.pbzchgretzou.qr>
Message-ID: <Pine.LNX.4.64.0802090130410.10911@kivilampi-30.cs.helsinki.fi>
References: <foheti$vgb$1@ger.gmane.org> <Pine.LNX.4.64.0802082014150.26116@fbirervta.pbzchgretzou.qr>
 <foild8$cnr$1@ger.gmane.org> <Pine.LNX.4.64.0802082353390.26116@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Feb 2008, Jan Engelhardt wrote:

> 
> On Feb 8 2008 22:34, ael wrote:
> >
> >Sure, I looked there in some depth. But some/most are special purpose or
> > 'locals'. One needs a map for the "main" repositories...
> 
> Indeed, a page on kernelnewbies.org with the most important repositories
> would be helpful.
> 
> Well, to start:
> 
> torvalds/linux-2.6.git	Mainline
> jgarzik/netdev-2.6.git	Network devices
> davem/net-2.6.git	Networking
> x86/linux-2.6-x86.git	x86
> mchehab/v4l-dvb.git	V4L and DVB
> bunk/trivial.git	Spellos, typos and the obvious
> 
> But it's not that easy. netdev-2.6.git for example regularly gets merged
> into net-2.6.git, so you get a fairly recent netdev tree by choosing
> either netdev or net.

Also explaining the rotation of those two trees would be useful (I
suppose some other subsystems too use somewhat similar rotation). I.e., 
net-2.6.26.git will eventually be opened and new development should be 
based on it (whenever such tree with a future version number is 
available), and that tree then becomes net-2.6.git once 2.6.25 is out. 
net-2.6.git is usually for fixes only unless merge window is currently 
open. These things come up quite often.


-- 
 i.
