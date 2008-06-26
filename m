Return-Path: <linux-kernel-owner+w=401wt.eu-S1754623AbYFZQBa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623AbYFZQBa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 12:01:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753931AbYFZQBR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 12:01:17 -0400
Received: from shadow.wildlava.net ([67.40.138.81]:34620 "EHLO
	shadow.wildlava.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988AbYFZQBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 12:01:15 -0400
Message-ID: <4863BD48.9000205@skyrush.com>
Date: Thu, 26 Jun 2008 10:01:12 -0600
From: Joe Peterson <joe@skyrush.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080620)
MIME-Version: 1.0
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
CC: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] UTC timestamp option for FAT filesystems
References: <4861D685.4070308@skyrush.com> <87od5pqh4o.fsf@basil.nowhere.org>	<4862DB28.3050001@skyrush.com> <48630286.2050006@skyrush.com>	<87wskck5wi.fsf@devron.myhome.or.jp> <48639863.808@skyrush.com> <877iccxnwi.fsf@devron.myhome.or.jp>
In-Reply-To: <877iccxnwi.fsf@devron.myhome.or.jp>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OGAWA Hirofumi wrote:
> Of course, UTC is right design for on disk format. But, this is FAT, the
> writing UTC means you modified the design of FAT. It is not a correct
> option, it is just a hack like I said, right?

I just looked at the FAT32 specification from Microsoft, and nowhere
does it say that FAT timestamps are in local time.  It does not mention
local time, time standards, or time zones at all.  Here it is:

http://www.microsoft.com/whdc/system/platform/firmware/fatgen.mspx

So there is nothing inherent in FAT's design or specification that
requires dates and times to be in local time.  It appears it is up to
the OS or device to convey a meaning by how the timestamps are used.
For this reason, I do not consider it a hack or a design
change/violation to optionally use UTC for the timestamps on a given FAT
volume.

					-Joe
