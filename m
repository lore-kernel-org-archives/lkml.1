Return-Path: <linux-kernel-owner+w=401wt.eu-S1760933AbXHXUhJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760933AbXHXUhJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 16:37:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760054AbXHXUg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 16:36:56 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:41032 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760021AbXHXUgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 16:36:55 -0400
Date: Fri, 24 Aug 2007 22:36:54 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Rob Landley <rob@landley.net>
cc: linux-kernel@vger.kernel.org
Subject: Re: What's up with CONFIG_BLK_DEV?
In-Reply-To: <Pine.LNX.4.64.0708242234250.28540@fbirervta.pbzchgretzou.qr>
Message-ID: <Pine.LNX.4.64.0708242234500.28540@fbirervta.pbzchgretzou.qr>
References: <200708241517.28475.rob@landley.net>
 <Pine.LNX.4.64.0708242234250.28540@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 24 2007 22:34, Jan Engelhardt wrote:
>On Aug 24 2007 15:17, Rob Landley wrote:
>>
>>CONFIG_BLOCK disables the block layer.
>>CONFIG_BLK_DEV disables the block devices.
>
>menuconfig BLK_DEV
>        bool "Block devices"
>        depends on BLOCK
>        default y
>        ---help---
>          Say Y here to get to see options for various different block device
>          drivers. This option alone does not add any kernel code.
>
>          If you say N, all options in this submenu will be skipped and disabled
>          only do this if you know what you are doing.

>>Is there _ever_ a time you want the block layer but no block devices?

Well, where do you think your hard disk drivers come from? Definitely 
not from the BLK_DEV menu...



	Jan
-- 
