Return-Path: <linux-kernel-owner+w=401wt.eu-S1751492AbYLHSJN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751492AbYLHSJN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 13:09:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750834AbYLHSI5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 13:08:57 -0500
Received: from an-out-0708.google.com ([209.85.132.244]:44842 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbYLHSI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 13:08:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=Sful5AXSDx9GLTWXwVohMy2jpDWaDtRxvBnYJs0XUZJuaZU5YiOiE+8ZyhYckaVhM6
         GnW51MgUXQ/v2eD1DhQxYmBNGi6X5LmZw2vT1ab+3tuZKmHo79YCXF+EarJHeL4QcyNA
         +1qtIfS/c+g+ayH7m9t0ajIG/mRS5K5zWyzjg=
Message-ID: <9ea470500812081008ydcd3d44g9494bcb7140a7ca6@mail.gmail.com>
Date: Mon, 8 Dec 2008 19:08:55 +0100
From: "Borislav Petkov" <petkovbb@googlemail.com>
Reply-To: petkovbb@gmail.com
To: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>
Subject: Re: [PATCH 0/4] ide: remove ide-scsi remnants
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
In-Reply-To: <200812081833.00406.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1228670471-3435-1-git-send-email-petkovbb@gmail.com>
	 <20081207184316.GA30260@gollum.tnic>
	 <200812081833.00406.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 8, 2008 at 6:33 PM, Bartlomiej Zolnierkiewicz
<bzolnier@gmail.com> wrote:
> On Sunday 07 December 2008, Borislav Petkov wrote:
>> On Sun, Dec 07, 2008 at 06:21:07PM +0100, Borislav Petkov wrote:
>> > Hi Bart,
>> >
>> > here are the patches removing bits and pieces belonging to the late ide-scsi :).
>> >
>>
>> here's the correct (and not reversed :)) diffstat though:
>>
>>  drivers/ide/ide-atapi.c  |   97 +++++++++-------------------------------------
>>  drivers/ide/ide-io.c     |    3 -
>>  drivers/ide/ide-ioctls.c |    3 +-
>>  drivers/ide/ide-probe.c  |    2 -
>>  include/linux/ide.h      |   34 ++++++----------
>>  5 files changed, 33 insertions(+), 106 deletions(-)
>
> Thanks, applied (though you could have combined all patches into
> single one -- it is one logical change after all).

It was a single patch originally but it looked pretty big and
unreadable and that's why I split it.


-- 
Regards/Gruss,
Boris
