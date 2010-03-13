Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759170Ab0CMNGb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 08:06:31 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:54033 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755355Ab0CMNGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 08:06:30 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Philippe De Muyter <phdm@macqel.be>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH vfat] allow retrieving entries with trailing dots
References: <20100310123257.GA2899@frolo.macqel>
	<87d3zc1bjo.fsf@devron.myhome.or.jp>
	<20100310161429.GA16799@frolo.macqel>
	<87hboow105.fsf@devron.myhome.or.jp>
	<20100310235808.GA4353@frolo.macqel>
	<87bpevryxt.fsf@devron.myhome.or.jp>
	<20100311120214.GA23767@frolo.macqel>
	<87y6hzni82.fsf@devron.myhome.or.jp>
	<20100313113150.GA11907@frolo.macqel>
Date: Sat, 13 Mar 2010 22:06:25 +0900
In-Reply-To: <20100313113150.GA11907@frolo.macqel> (Philippe De Muyter's
	message of "Sat, 13 Mar 2010 12:31:50 +0100")
Message-ID: <87wrxg9xri.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.93 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Philippe De Muyter <phdm@macqel.be> writes:

>> No, this breaks consistency. With this patch, unlink("a."), then
>> open("a.", O_CREAT) and write(), the result depend on existent
>> files. This patch is providing two files on one name.
>
> To avoid that, we could remember that we have found a filename with a trailing
> dot (in that directory or in the whole disk), and if that's the case then
> we are allowed to create filenames with trailing dots.

It sounds like dirty hack, and it would make more complex situations.
And the user can umount/mount (or reboot, etc.) before open().

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
