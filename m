Return-Path: <linux-kernel-owner+w=401wt.eu-S932410AbXBSRcM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932410AbXBSRcM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 12:32:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932418AbXBSRcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 12:32:12 -0500
Received: from mail.parknet.jp ([210.171.160.80]:1567 "EHLO parknet.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932410AbXBSRcL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 12:32:11 -0500
X-AuthUser: hirofumi@parknet.jp
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Racy NLS behaviour in FAT (and possible other fs)
References: <45D9C80A.2030905@drzeus.cx> <87tzxim6ic.fsf@duaron.myhome.or.jp>
	<45D9D848.4010608@drzeus.cx>
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Tue, 20 Feb 2007 02:32:03 +0900
In-Reply-To: <45D9D848.4010608@drzeus.cx> (Pierre Ossman's message of "Mon\, 19 Feb 2007 18\:03\:04 +0100")
Message-ID: <87ps86m4to.fsf@duaron.myhome.or.jp>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.93 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman <drzeus-list@drzeus.cx> writes:

> OGAWA Hirofumi wrote:
>>> I'm experiencing a rather odd behaviour with the character set
>>> conversion. If I mount a vfat fs with utf8 and then create a file
>>> with invalid utf-8 sequences, the file will briefly exist with these
>>> invalid sequences, then quickly convert to a stripped version.
>>
>> Yes. utf8 support is broken, and it will fail to convert letter case
>> on many case. And it's why that is not recommended.
>
> Is there any ongoing work to fix this? UTF-8 is standard on more or less
> every distribution these days.

Yes. But sorry, I don't have any plan and time to fix it now.

If you are using "iocharset=utf8" now, "codepage=cp???,iocharset=xxx,utf8"
might help a bit.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
