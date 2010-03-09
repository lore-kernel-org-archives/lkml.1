Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157Ab0CIAFO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 19:05:14 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53068 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753884Ab0CIAFL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 19:05:11 -0500
Date: Tue, 9 Mar 2010 01:05:08 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Stefan Achatz <stefan_achatz@web.de>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Jussi Kivilinna <jussi.kivilinna@mbnet.fi>, wylda@volny.cz,
       Pavel Machek <pavel@suse.cz>,
       Alessandro Guido <ag@alessandroguido.name>,
       Tomas Hanak <tomas.hanak@gmail.com>, Jason Noble <nobleja@polezero.com>,
       simon.windows@gmail.com, Sean Hildebrand <silverwraithii@gmail.com>,
       Sid Boyce <sboyce@blueyonder.co.uk>, Henning Glawe <glaweh@debian.org>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] Added locks for sysfs attributes and internal
 data.
In-Reply-To: <201003081704.30119.stefan_achatz@web.de>
Message-ID: <alpine.LNX.2.00.1003090103240.17799@pobox.suse.cz>
References: <201002200911.53900.stefan_achatz@web.de> <31758929.1286552.1266912188132.JavaMail.fmail@mwmweb006> <20100226074422.GA17062@core.coreip.homeip.net> <201003081704.30119.stefan_achatz@web.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Mar 2010, Stefan Achatz wrote:

> From 47678162da8e374d6f132db21d89b718ee5cfbd1 Mon Sep 17 00:00:00 2001
> From: Stefan Achatz <erazor_de@users.sourceforge.net>
> Date: Mon, 8 Mar 2010 16:54:19 +0100
> Subject: [PATCH 4/4] Added locks for sysfs attributes and internal data.
> 
> Added mutex lock to prevent different processes from accessing
> sysfs attributes at the same time.
> Added spin lock for internal data.
> ---
>  drivers/hid/hid-roccat-kone.c |  246 ++++++++++++++++++++++++++++------------
>  drivers/hid/hid-roccat-kone.h |    9 +-
>  2 files changed, 179 insertions(+), 76 deletions(-)

Stefan,

could you please submit the rest of the patch series as well? I seem to 
have got only "4/4" patch of your series, but not the rest of the roccat 
driver (I recall there were some review comments raised after your initial 
submission of the driver, so full respin would be appreciated).

Also, please don't forget to put proper Signed-off-by: lines to the 
patches you submit with intention for upstream merge.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
