Return-Path: <linux-kernel-owner+w=401wt.eu-S965238AbXGSQDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965238AbXGSQDT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 12:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937158AbXGSQCt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 12:02:49 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:50684 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933009AbXGSQCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 12:02:46 -0400
Date: Thu, 19 Jul 2007 18:02:45 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Jean Delvare <khali@linux-fr.org>
cc: Kay Sievers <kay.sievers@vrfy.org>, Greg KH <gregkh@suse.de>,
       Tejun Heo <htejun@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: sysfs root link count broken in 2.6.22-git5
In-Reply-To: <20070719104150.6c5c5165@hyperion.delvare>
Message-ID: <Pine.LNX.4.64.0707191802050.31013@fbirervta.pbzchgretzou.qr>
References: <20070715124232.4e371bf9@hyperion.delvare> <20070717034844.GB11602@suse.de>
 <20070717131255.71b7e72e@hyperion.delvare> <20070717183652.GG9702@suse.de>
 <20070717230530.64d9a896@hyperion.delvare> <20070718033828.GA8582@suse.de>
 <20070718220652.15ad2c4b@hyperion.delvare> <3ae72650707181744l47d6cbc6m75b7d9292959a245@mail.gmail.com>
 <20070719104150.6c5c5165@hyperion.delvare>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 19 2007 10:41, Jean Delvare wrote:
>> Well, just check if /sys/devices/ exists, that should be cheap enough. :)
>
>Yes, this is a possibility, and one I had considered at first. But I
>wasn't sure which subdirectory to check. sysfs isn't well known for its
>stability, and I didn't know which directories exist since the
>early days of sysfs, and which do not. For example, fs, kernel and
>module were not present in 2.6.5. I am also not sure if directories
>which exist today are guaranteed to exist forever. This is the reason
>why I decided to check the link count instead, basically checking that
>at least one subdirectory exists, without having to name it.

If anything exists, it is likely to be mounted.
opendir, 3x readdir, exit the loop, done :)


	Jan
-- 
