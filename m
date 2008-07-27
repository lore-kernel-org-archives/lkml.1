Return-Path: <linux-kernel-owner+w=401wt.eu-S1758292AbYG0QDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758292AbYG0QDg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 12:03:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752870AbYG0QD1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 12:03:27 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:6942 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070AbYG0QD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 12:03:26 -0400
Message-ID: <1b51b6f80807270903v467b07f3x24c4a8aace97c33@mail.gmail.com>
Date: Sun, 27 Jul 2008 18:03:25 +0200
From: "Niels de Vos" <niels@nixpanic.net>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: [RESEND] [PATCH] linux/fs.h should include linux/path.h
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       adobriyan@gmail.com
In-Reply-To: <20080727155852.GO9301@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <488C6B4E.8040205@nixpanic.net>
	 <20080727155852.GO9301@cs181140183.pp.htv.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 27, 2008 at 5:58 PM, Adrian Bunk <bunk@kernel.org> wrote:
> On Sun, Jul 27, 2008 at 02:34:22PM +0200, Niels de Vos wrote:
>> <linux/fs.h> defines 'struct file' which uses 'struct path'. However
>> <linux/path.h> is not being included.
>>
>> Signed-off-by: Niels de Vos <niels.devos@wincor-nixdorf.com>
>>
>> ---
>> diff --git a/include/linux/fs.h b/include/linux/fs.h
>> index d8e2762..a14f1c4 100644
>> --- a/include/linux/fs.h
>> +++ b/include/linux/fs.h
>> @@ -289,6 +289,7 @@ extern int dir_notify_enable;
>>  #include <linux/mutex.h>
>>  #include <linux/capability.h>
>>  #include <linux/semaphore.h>
>> +#include <linux/path.h>
>>...
>
> This #include was recently added a few lines above.

Okay, looks like I've missed that commit.

Thanks, Niels
