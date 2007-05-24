Return-Path: <linux-kernel-owner+w=401wt.eu-S1752522AbXEXSwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522AbXEXSwV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 14:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750794AbXEXSwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 14:52:14 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:60694 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbXEXSwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 14:52:13 -0400
X-Greylist: delayed 989 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 May 2007 14:52:13 EDT
Date: Thu, 24 May 2007 20:35:09 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Make prepare_namespace() wait for devices
Message-ID: <20070524183509.GA30518@aepfle.de>
References: <4655834F.3050301@drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4655834F.3050301@drzeus.cx>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, Pierre Ossman wrote:

> init: wait for asynchronously scanned block devices

init/do_mounts.c:242:__setup("rootdelay=", root_delay_setup);

Why does that not work for you and how does your patch fix it?
