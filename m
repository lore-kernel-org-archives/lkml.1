Return-Path: <linux-kernel-owner+w=401wt.eu-S1754839AbYIDEXf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839AbYIDEXf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 00:23:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751168AbYIDEX0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 00:23:26 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:43721 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbYIDEXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 00:23:25 -0400
Date: Thu, 04 Sep 2008 13:22:55 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "Nir Tzachar" <tzachar@grad120a.cs.bgu.ac.il>
Subject: Re: [PATCH] ncurses based config
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       zippel@linux-m68k.org, linux-kbuild@vger.kernel.org,
       Nir Tzachar <nir@tzachar.com>
In-Reply-To: <1220469076-16487-1-git-send-email-nir@tzachar.com>
References: <1220469076-16487-1-git-send-email-nir@tzachar.com>
Message-Id: <20080904132008.DB14.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> This patch was inspired by the kernel projects page, where an ncurses
> replacement for menuconfig was mentioned (by Sam Ravnborg).
> 
> Building on menuconfig, this patch implements a more modern look interface using
> ncurses and ncurses' satellite libraries (menu, panel, form). The implementation
> does not depend on lxdialog, which is currently distributed with the kernel.
> 
> The only change outside of nconf.c is due to a name clash: both ncurses and
> lkc.h define a fucntion named menu_init(). I changed the internal version's
> name. 
> 
> Please consider the patch for merging. Comments are appreciated.

if I run "make nconfig" on GNU screen, I can't see cursor position.
is this intensional?



