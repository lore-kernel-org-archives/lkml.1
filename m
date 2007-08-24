Return-Path: <linux-kernel-owner+w=401wt.eu-S1757812AbXHXUey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757812AbXHXUey (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 16:34:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752086AbXHXUep
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 16:34:45 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:50649 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbXHXUeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 16:34:44 -0400
Date: Fri, 24 Aug 2007 22:34:43 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Rob Landley <rob@landley.net>
cc: linux-kernel@vger.kernel.org
Subject: Re: What's up with CONFIG_BLK_DEV?
In-Reply-To: <200708241517.28475.rob@landley.net>
Message-ID: <Pine.LNX.4.64.0708242234250.28540@fbirervta.pbzchgretzou.qr>
References: <200708241517.28475.rob@landley.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 24 2007 15:17, Rob Landley wrote:
>
>CONFIG_BLOCK disables the block layer.
>CONFIG_BLK_DEV disables the block devices.

menuconfig BLK_DEV
        bool "Block devices"
        depends on BLOCK
        default y
        ---help---
          Say Y here to get to see options for various different block device
          drivers. This option alone does not add any kernel code.

          If you say N, all options in this submenu will be skipped and disabled
          only do this if you know what you are doing.


	Jan
-- 
