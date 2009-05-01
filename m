Return-Path: <linux-kernel-owner+w=401wt.eu-S1756929AbZEAMwf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756929AbZEAMwf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 08:52:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757177AbZEAMwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 08:52:10 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:52084 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746AbZEAMwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 08:52:07 -0400
Message-ID: <49FAF074.9080202@monstr.eu>
Date: Fri, 01 May 2009 14:52:04 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-arch@vger.kernel.org,
       Remis Lima Baima <remis.developer@googlemail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/27] asm-generic: add minimal cache description
References: <cover.1241105648.git.arnd@arndb.de> <2d8ccc76119d2379859480dbb8f7562743a1de58.1241105648.git.arnd@arndb.de> <c1a198be0904302303h73c5168fi73f8dc24dc677965@mail.gmail.com> <200905011427.05099.arnd@arndb.de>
In-Reply-To: <200905011427.05099.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Friday 01 May 2009, Michal Simek wrote:
>>> +#define copy_to_user_page(vma, page, vaddr, dst, src, len) \
>>> +       memcpy(dst, src, len)
>>> +#define copy_from_user_page(vma, page, vaddr, dst, src, len) \
>>> +       memcpy(dst, src, len)
>>
>> IMHO these two macros will generate cast errors.
> 
> I did not see errors here, can you clarify? Note that despite the name,
> they don't take a __user pointer. Maybe they should be inline functions
> to make that more obvious.

you are right here with __user.
x86 use it as inline function.

Michal

> 
> 	Arnd <><


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
