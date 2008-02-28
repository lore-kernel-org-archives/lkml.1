Return-Path: <linux-kernel-owner+w=401wt.eu-S1760899AbYB1QVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760899AbYB1QVk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 11:21:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752671AbYB1QVd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 11:21:33 -0500
Received: from wf-out-1314.google.com ([209.85.200.175]:31639 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498AbYB1QVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 11:21:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=TRtZ0i8XZi1bKUlgfb7mO2ou35p6GWPjXBdA+jw24+XZvhESpeOJVlcjlfWQnHblfhisFIYyd3tRQUqS29DHy5b9cSiG/PKogNTXQhY6QpOOJqmLV0Pqwiicuxe0nXg6wNrxkTrtbUh5J5mnxvImIy/y3vcZvaG+SsXL+em5eIY=
Message-ID: <e9e943910802280821q7fa5d0e2ya92023d46bcdb392@mail.gmail.com>
Date: Thu, 28 Feb 2008 16:21:29 +0000
From: "Duane Griffin" <duaneg@dghda.com>
To: "Abel Bernabeu" <abel.bernabeu@gmail.com>
Subject: Re: kernel BUG at fs/ext3/namei.c:383
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <15577be70802280233n412108exb0a5f03a2405ceca@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <15577be70802280233n412108exb0a5f03a2405ceca@mail.gmail.com>
X-Google-Sender-Auth: faa3f32342197f5a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/02/2008, Abel Bernabeu <abel.bernabeu@gmail.com> wrote:
> My kernel says that has a bug.
>
>  I attach two logs:
>
>  1) The output of dmesg.
>  2) The output printed in my console.
>
>  In defense of Linux I have to admit that I previously used the EXT3
>  filesystem that kernel was trying to access with Windows (by means of
>  an EXT2 driver from http://www.fs-driver.org/).

This is fixed in recent kernels (commit
3d82abae9523c33d4a16fdfdfd2bdde316d7b56a, to be precise). The windows
driver is corrupting the filesystem but ext3 shouldn't BUG and if you
update to a recent kernel it won't. If you can't update then you
should e2fsck the filesystem after using the windows driver. That
should fix up the corruption.

Also, for future reference, LKML folks generally don't like
attachments, so if possible just include logs or other info inline
next time.

>  Yours, Abel.

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
