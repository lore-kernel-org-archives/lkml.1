Return-Path: <linux-kernel-owner+w=401wt.eu-S1756166AbYFZHdF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166AbYFZHdF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 03:33:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753281AbYFZHcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 03:32:54 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:60598 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbYFZHcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 03:32:53 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Joe Peterson <joe@skyrush.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] UTC timestamp option for FAT filesystems
References: <4861D685.4070308@skyrush.com> <87od5pqh4o.fsf@basil.nowhere.org>
	<4862DB28.3050001@skyrush.com> <48630286.2050006@skyrush.com>
Date: Thu, 26 Jun 2008 16:32:45 +0900
In-Reply-To: <48630286.2050006@skyrush.com> (Joe Peterson's message of "Wed,
	25 Jun 2008 20:44:22 -0600")
Message-ID: <87wskck5wi.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Peterson <joe@skyrush.com> writes:

> So FAT filesystem timestamps make sense in one of two modes for a given
> volume: local time or UTC.  The former handles volumes used under
> Windows well, and the latter would be extremely useful for other devices
> which use FAT filesystems but need to have a more sensible "real" time
> format (like, as I pointed out, digital cameras).

Um, so how does the camera show the timestamp of file? UTC seems to be
hack for changing FAT for Linux. Arbitrary value is more useful and
correct option, I think.

It will be specified the timezone of FAT on one disk. So, the timestamp
is right for specified timezone on Windows always, on Linux should be
always right. If you want to write, of course, you can specify UTC by it
to write timestamp as UTC to FAT.

No?
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
