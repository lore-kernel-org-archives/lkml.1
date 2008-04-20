Return-Path: <linux-kernel-owner+w=401wt.eu-S1756713AbYDTQBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713AbYDTQBi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 12:01:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752717AbYDTQB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 12:01:28 -0400
Received: from lazybastard.de ([212.112.238.170]:56200 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955AbYDTQB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 12:01:28 -0400
Date: Sun, 20 Apr 2008 18:01:15 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: matthieu castet <castet.matthieu@free.fr>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Alex Dubov <oakad@yahoo.com>
Subject: Re: Smartmedia/xd card support - request for comments
Message-ID: <20080420160115.GA20694@logfs.org>
References: <4809ADF7.9040604@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4809ADF7.9040604@free.fr>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 April 2008 10:31:51 +0200, matthieu castet wrote:
>
> I wonder if mtd shouldn't modified to handler more clever controller :
> I saw some raw nand controller where you can program a batch of 
> command/read/write/ecc checking (that work on a internal RAM of the 
> controller (and may be use DMA)) and all you have to do is to wait the 
> controller do the job.
> These controllers are very hard to integrate in current nand layer 
> because it is very low level controller oriented.

The obvious solution is to have seperate io scheduling from io
completion.  Requires an asynchronous interface to read/write and some
sort of request queue.

Not quite as obvious is the question of whether to add all this to mtd
or to replace mtd with block devices, which already have it.

Jörn

-- 
Never argue with idiots - first they drag you down to their level,
then they beat you with experience.
-- unknown
