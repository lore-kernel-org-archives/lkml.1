Return-Path: <linux-kernel-owner+w=401wt.eu-S966354AbXEGTgb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966354AbXEGTgb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 15:36:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966348AbXEGTg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 15:36:26 -0400
Received: from terminus.zytor.com ([192.83.249.54]:37904 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966342AbXEGTgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 15:36:25 -0400
Message-ID: <463F7F30.5010200@zytor.com>
Date: Mon, 07 May 2007 12:34:08 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
CC: Roland Kuhn <rkuhn@e18.physik.tu-muenchen.de>,
       Andrey Borzenkov <arvidjaar@mail.ru>, linux-kernel@vger.kernel.org
Subject: Re: Long file names in VFAT broken with iocharset=utf8
References: <200705072151.20104.arvidjaar@mail.ru>	<60F72760-C801-4F60-BF47-C661B4B5BE26@e18.physik.tu-muenchen.de> <87fy685w0m.fsf@duaron.myhome.or.jp>
In-Reply-To: <87fy685w0m.fsf@duaron.myhome.or.jp>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

OGAWA Hirofumi wrote:
>>>
>> PATH_MAX specifically counts _bytes_ not characters, so UTF-8 does  
>> not matter. ISTR that PATH_MAX was 256 at some point, but I just  
>> quickly grepped /usr/include and found various mention of 4096, so  
>> where's the central repository for this configuration item? A hard- 
>> coded value of 256 somewhere inside the kernel smells like a bug.
> 
> There is a nasty issue here. FAT is limited by 255 unicode chars or so.
> So, we would need to count number of unicode chars of filename.
> 
> That's not implemented currently.

Note also there is PATH_MAX and NAME_MAX; the latter is 255 I believe.

POSIX allows NAME_MAX to vary on a filesystem by filesystem basis,
although that is not currently implemented in Linux.

	-hpa
