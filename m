Return-Path: <linux-kernel-owner+w=401wt.eu-S1757268AbYJMJ2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757268AbYJMJ2e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 05:28:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756137AbYJMJ20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 05:28:26 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:41571 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476AbYJMJ2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 05:28:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=BhFiggHjTZVrKwygrcTIIDNtjKUntO3eOSWPIt2HN0BaUTu4D7kF1Vx0iijqn/fwUn
         LzxW+dcCejPUreE7w65WzuTIwVkNJwfPKiHCDwiExz0mUBdbK42QeTyv70gApf7Hobta
         0sCoio9AY7yVcMAhJQ7lkE55tfuFad/0cnFm0=
Message-ID: <912ec82a0810130228m3e9e11bcyfcabe1ab46fb0b6b@mail.gmail.com>
Date: Mon, 13 Oct 2008 11:28:23 +0200
From: "Neshama Parhoti" <pneshama@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: section mismatch with a platform driver
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20081013085111.GB29938@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <912ec82a0810130119g795c91ffr1083d7e8459a6db1@mail.gmail.com>
	 <20081013085111.GB29938@cs181140183.pp.htv.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Adrian and thank you for the help!

On Mon, Oct 13, 2008 at 10:51 AM, Adrian Bunk <bunk@kernel.org> wrote:
> On Mon, Oct 13, 2008 at 10:19:05AM +0200, Neshama Parhoti wrote:
>> WARNING: vmlinux.o(.data+0x44bc4): Section mismatch: reference to
>> .init.text:my_probe_func (between 'my_platform_struct' and
>> 'debug_level_variable')
>>
>> If I understand correctly, it shouts about my probe function being
>> referenced from the data section:
>>
>> static struct platform_driver my_platform_struct = {
>>       .probe          = my_probe_func,
>>       .remove         = my_remove,
>>       .suspend        = my_suspend,
>>       .resume         = my_resume,
>>       .driver         = {
>>               .name = DRIVER_NAME,
>>       },
>> };
>>
> It complains about "my_probe_func", and that's not even in the code
> you posted.

It happens even if I use an empty function like this:

static int __init my_probe_func(struct platform_device *pdev)
{
	return 0;
}


any idea what's the problem ?

thanks again!
pnesh
