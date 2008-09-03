Return-Path: <linux-kernel-owner+w=401wt.eu-S1754703AbYICLNz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703AbYICLNz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 07:13:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751166AbYICLNq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 07:13:46 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:40661 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbYICLNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 07:13:45 -0400
Subject: Re: [patch 2/8] m68k: Reverse platform MMU logic so Sun 3 is last
From: Laurent Vivier <Laurent.Vivier@bull.net>
To: Adrian Bunk <bunk@kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080903073629.GD4104@cs181140183.pp.htv.fi>
References: <20080903071542.615137611@mail.of.borg>
	 <20080903071741.424551678@mail.of.borg>
	 <20080903073629.GD4104@cs181140183.pp.htv.fi>
Content-Type: text/plain; charset=utf-8
Organization: Bull S.A.S.
Date: Wed, 03 Sep 2008 13:13:41 +0200
Message-Id: <1220440421.4159.22.camel@frecb07144>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 03 septembre 2008 à 10:36 +0300, Adrian Bunk a écrit :
> On Wed, Sep 03, 2008 at 09:15:44AM +0200, Geert Uytterhoeven wrote:
> > From: Geert Uytterhoeven <geert@linux-m68k.org>
> > 
> > Currently Sun 3 support is the first platform option, as the Sun 3 MMU is
> > incompatible with standard Motorola MMUs. However, this means that
> > `allmodconfig' enables support for Sun 3, and thus disables support for all
> > other platforms.
> >...
> 
> I hope it isn't too heretical to ask whether Sun 3 support actually has 
> users and works?
> 
> Apollo support was broken for over 7 years without anyone noticing, and 
> it might not be the only m68k platform that is long unused.
> 
> Do you have any overview of which m68k platforms still have users?

At least 4 users for amiga and 2 for mac :-P

#rank name                            inst  vote   old recent no-files
42014 linux-image-2.6-amiga              4     0     0     0     4
53844 linux-image-2.6-mac                2     0     0     0     2

from http://popcon.debian.org/by_inst

I'm a mac m68k user (who is the other one ???)

Laurent
-- 
----------------- Laurent.Vivier@bull.net  ------------------
  "La perfection est atteinte non quand il ne reste rien à
ajouter mais quand il ne reste rien à enlever." Saint Exupéry

