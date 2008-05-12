Return-Path: <linux-kernel-owner+w=401wt.eu-S1756634AbYELXV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634AbYELXV2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 19:21:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753384AbYELXVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 19:21:21 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:49800 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753887AbYELXVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 19:21:20 -0400
Date: Tue, 13 May 2008 01:21:19 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Georgi Chorbadzhiyski <gf@unixsol.org>
cc: xfs@oss.sgi.com, jfs-discussion@lists.sourceforge.net,
       cluster-devel@redhat.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Unneeded kernel threads (xfs, jfs, gfs2)
In-Reply-To: <4828CAC6.3090402@unixsol.org>
Message-ID: <alpine.LNX.1.10.0805130115090.25441@fbirervta.pbzchgretzou.qr>
References: <4828CAC6.3090402@unixsol.org>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tuesday 2008-05-13 00:55, Georgi Chorbadzhiyski wrote:
>
>Not needed here, because no jfs partition is in use.
>Not needed here, because no xfs partition is in use.
>I dont use gfs2

You miss the best of Linux. So, why not unload the modules?

>>  1141 ?        S<     0:00  \_ [block-osm/1]
>
>What is osm? Can't find anything in kernel config?

drivers/message/i2o/i2o_block.c:#define OSM_NAME        "block-osm"

>>  1148 ?        S<     0:00  \_ [khpsbpkt]
>
>What is this?

ieee1394/ieee1394_core.c:static struct task_struct *khpsbpkt_thread;
