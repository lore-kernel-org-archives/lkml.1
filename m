Return-Path: <linux-kernel-owner+w=401wt.eu-S1755382AbYKKKFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382AbYKKKFk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 05:05:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755471AbYKKKFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 05:05:19 -0500
Received: from an-out-0708.google.com ([209.85.132.246]:16040 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755438AbYKKKFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 05:05:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=fWlCshSaLXdhBfOMGjcBqk1sa6lIziLlg1fTcO7k6zlENwlmT0GwIkJxcxBcrrE3tQ
         3VbS78IaD+Q4xvdwmAZFrBiIugL+XD1dCr0yjn7T75W7A/hpSW+Vp1rxXHdKbPf9qwRv
         X1pzv42CmdATIIv0iK88EY/CukWlCQNFtZKBg=
Message-ID: <5d9b736f0811110205q719ad246t81cc00fd9997b10@mail.gmail.com>
Date: Tue, 11 Nov 2008 11:05:15 +0100
From: "Michal Januszewski" <michalj@gmail.com>
To: "Geert Uytterhoeven" <geert@linux-m68k.org>
Subject: Re: [Linux-fbdev-devel] [PATCH] drivers: process failure of sysfs_create_group()
Cc: "Jianjun Kong" <jianjun@zeuux.org>,
       linux-fbdev-devel@lists.sourceforge.net,
       Linux-Kernel-Mailing-List <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0811102229170.19341@anakin>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081110105332.GA19358@ubuntu>
	 <Pine.LNX.4.64.0811102229170.19341@anakin>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2008 at 22:30, Geert Uytterhoeven <geert@linux-m68k.org> wrote:

>> When fail to call sysfs_create_group(), it should recycle resources and return the error.
>> This patch fix for processing failure of sysfs_create_group().
>
> IIRC, the reasoning behind the current code is that a failure to create sysfs
> entries is not critical, as it doesn't impact the correct functioning of the
> core of the driver.

That's correct -- that was exactly my reasoning behind this code.

-- 
Michal Januszewski, Gentoo Linux Developer
http://people.gentoo.org/spock
