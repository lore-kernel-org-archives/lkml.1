Return-Path: <linux-kernel-owner+w=401wt.eu-S1755403AbXHZRoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403AbXHZRoR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 13:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754233AbXHZRoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 13:44:06 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:57705 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754091AbXHZRoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 13:44:03 -0400
Date: Sun, 26 Aug 2007 19:44:02 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Fred Tyler <fredty8@gmail.com>
cc: vda.linux@googlemail.com, linux-kernel@vger.kernel.org
Subject: Re: Slow, persistent memory leak in 2.6.20
In-Reply-To: <466ad3f90708261041g72fee1a2q2f541161884d4499@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0708261943260.15614@fbirervta.pbzchgretzou.qr>
References: <466ad3f90708260739v645294b9t641cb8258dcc4f4@mail.gmail.com> 
 <Pine.LNX.4.64.0708261752260.15614@fbirervta.pbzchgretzou.qr> 
 <466ad3f90708260916x5d19d0d3hd828e63520960192@mail.gmail.com> 
 <200708261803.12717.vda.linux@googlemail.com>
 <466ad3f90708261041g72fee1a2q2f541161884d4499@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 26 2007 13:41, Fred Tyler wrote:
>
>I'm going to run drop_caches on the 2.6.20 machines tonight and see
>what happens...

Better add "Slab" to your graphs, that looks like it's the amount of
non-cache kernel memory used.

	Jan
-- 
