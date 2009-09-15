Return-Path: <linux-kernel-owner+w=401wt.eu-S934344AbZIOC6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934344AbZIOC6i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 22:58:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934237AbZIOC6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 22:58:33 -0400
Received: from mail-yw0-f174.google.com ([209.85.211.174]:37356 "EHLO
	mail-yw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933518AbZIOC6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 22:58:32 -0400
Message-ID: <4AAF02A6.2040601@vflare.org>
Date: Tue, 15 Sep 2009 08:27:42 +0530
From: Nitin Gupta <ngupta@vflare.org>
Reply-To: ngupta@vflare.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: justinmattock@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [mmotm] change "getline" to "get_line" to avoid C library
  confusion
References: <d760cf2d0909132059j9852955s429be24aea1722ee@mail.gmail.com> <20090914152427.71d1fa93.akpm@linux-foundation.org>
In-Reply-To: <20090914152427.71d1fa93.akpm@linux-foundation.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/15/2009 03:54 AM, Andrew Morton wrote:
> On Mon, 14 Sep 2009 09:29:30 +0530
> Nitin Gupta<ngupta@vflare.org>  wrote:
>
>> Reintroduce this change to fix compilation error on mmotm.
>> (Original change by Justin P. Mattock)


>
> I'm all confused again.  This:
>
> commit d15bd1067b1fcb2b7250d22bc0c7c7fea0b759f7
> Author:     Justin P. Mattock<justinmattock@gmail.com>
> AuthorDate: Sat Mar 7 13:31:29 2009 +0100
> Commit:     Sam Ravnborg<sam@ravnborg.org>
> CommitDate: Sat Mar 7 13:31:29 2009 +0100
>
>      kbuild: fix C libary confusion in unifdef.c due to getline()
>
> went into mainline months ago and afaict nothing has subsequently
> changed in that area?
>
>

This is already fixed in mainline but this patch is for mmotm. On mmotm,
this change is not present. So, I'm now having compilation error while
compiling mmotm tree (not mainline):

mmotm/scripts/unifdef.c:209: error: conflicting types for ‘getline’
/usr/include/stdio.h:653: note: previous declaration of ‘getline’ was here
make[3]: *** [scripts/unifdef] Error 1
make[2]: *** [__headers] Error 2
make[1]: *** [vmlinux] Error 2
make: *** [sub-make] Error 2


Thanks,
Nitin




