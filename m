Return-Path: <linux-kernel-owner+w=401wt.eu-S934857AbZLGJnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934857AbZLGJnm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 04:43:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934800AbZLGJnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 04:43:39 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:35565 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934781AbZLGJni convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 04:43:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YHXc5VSIv3u+CibmIPC5pK81mkpWv05zDi36Ax72nDMiYi+NO2U6IKdEOImwy6XDz5
         +CTH6Tgm/J/s0n4Y4No8jUMQbxduF2OlkaoSwzjnEDQE5qXEqKd4rQmc/PGUoJvzU+V+
         5GEg0/kakWm7dFax5zE6HOMlutRlZyOeTNFt0=
MIME-Version: 1.0
In-Reply-To: <4B1C38B5.2060204@tremplin-utc.net>
References: <40a4ed590911190052w63a18bb7p516a5e759e0ffa23@mail.gmail.com>
	 <4B055609.9030306@tremplin-utc.net>
	 <4B1A53AE.9020707@tremplin-utc.net>
	 <40a4ed590912060741n4042ab1bg8188cd4eff28ca78@mail.gmail.com>
	 <4B1BDAA3.10601@gentoo.org>
	 <40a4ed590912060835s61aea6aqfe6780395bfd2993@mail.gmail.com>
	 <4B1C38B5.2060204@tremplin-utc.net>
Date: Mon, 7 Dec 2009 10:43:43 +0100
Message-ID: <40a4ed590912070143j231e07b6uafd04d0f2ee15dca@mail.gmail.com>
Subject: Re: Intel Poulsbo [psb] driver for Asus Eeepc 1101
From: Zeno Davatz <zdavatz@gmail.com>
To: =?ISO-8859-1?Q?=C9ric_Piel?= <Eric.Piel@tremplin-utc.net>
Cc: Zac Medico <zmedico@gentoo.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 7, 2009 at 12:05 AM, Éric Piel <Eric.Piel@tremplin-utc.net> wrote:
> Op 06-12-09 17:35, Zeno Davatz schreef:
> :
>>
>> Yes, thanks. That helped another step. I am getting the correct screen
>> resolution after enabling that in the kernel as well. The boot [ok]
>> messages of Gentoo are in a higher resolution now though. That is a
>> good start.
>>
>> But after my X starts I get a black screen with a
>>
>> -
>>
>> in the top left corner. They keyboard also does not work. May be an
>> X.org config problem.
>>
> I've got similar behaviour here if psb is loaded before the X server starts
> (aka there is a framebuffer). If the console is just ascii (no vga=...
> argument on the kernel boot line, and no "modprobe psb"), then X starts
> fine.

What are the exact options that you are using for "no vga"?

My terminal seems to automatically load "psb". I have no modprobe
loading "psb" explicitly.

Best
Zeno
