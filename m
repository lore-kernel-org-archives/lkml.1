Return-Path: <linux-kernel-owner+w=401wt.eu-S1753603Ab0ARPK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603Ab0ARPK5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 10:10:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752843Ab0ARPK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 10:10:56 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:37799 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759Ab0ARPKz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 10:10:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=WT+2LCUnXWFZ4pHwsnNEIqGWHABaD6rln3Dz0gcVwcQpBQ9lmYxTf82GiWQfIdqr+u
         6iaVDIF1TG8p7pbVzrGE+MdRB4Uo2c/QwSIrlUV3czLVq0rSP1sUWuJOqyo80ym6vaiB
         kuXhO6Q7z2QJ9hqrgjoF1GA9XL/47ItHBpk3M=
MIME-Version: 1.0
In-Reply-To: <4B53BDC5.1010201@cn.fujitsu.com>
References: <cover.1263675077.git.andre.goddard@gmail.com> 
	<30e5fd087ee6fbe992cde8f09d945ed160b0c117.1263675077.git.andre.goddard@gmail.com> 
	<4B53BDC5.1010201@cn.fujitsu.com>
From: =?ISO-8859-1?Q?Andr=E9_Goddard_Rosa?= <andre.goddard@gmail.com>
Date: Mon, 18 Jan 2010 13:10:35 -0200
Message-ID: <b8bf37781001180710s197e8601r49c94e67f1f5d98@mail.gmail.com>
Subject: Re: [PATCH 2/2] string: teach strnstr() to not search past 
	NUL-terminator
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       Alex Riesen <raa.lkml@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 17, 2010 at 11:47 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> André Goddard Rosa wrote:
>> As noticed by Alex Riesen at:
>> http://marc.info/?l=linux-kernel&m=126364040821071&w=2
>>
> Please don't make this change, it's the user's responsibility
> to make sure @len won't exceed @s1's length.
>
> All the string functions of "n" version should work when
> @s1 is not null-terminated, so don't call strlen() on @s1.

Fair enough, agreed.

Thank you,
André
