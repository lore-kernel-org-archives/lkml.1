Return-Path: <linux-kernel-owner+w=401wt.eu-S1754724AbYKRRMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724AbYKRRMj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 12:12:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753114AbYKRRMW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 12:12:22 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:65262 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824AbYKRRMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 12:12:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=cc:message-id:from:to:in-reply-to:content-type
         :content-transfer-encoding:mime-version:subject:date:references
         :x-mailer;
        b=KocYGvHF1XIlr7176QvT8jOwD9NfVsiFwa6lMm/ekU0zCYeXpU+t468E0XuHRprvXb
         dmM0I3gNN/45bkeMgjcxL7hkEEZ1foN8pF6hjezNb5cKOhrihJnC6a7IH0fGSUXDZBoc
         nFdD6YPPj4RTCFRq0H8XZ287yzjeH+Xs6fAUA=
Cc: "Takashi Iwai" <tiwai@suse.de>, "Jaroslav Kysela" <perex@perex.cz>,
       kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <B39062E8-28BA-4701-A8A9-A25DA07482EA@gmail.com>
From: Richard Holden <aciddeath@gmail.com>
To: "Hannes Eder" <hannes@hanneseder.net>
In-Reply-To: <154e089b0811180906r69099866vf0b80cd40d7e2cc7@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: Re: [PATCH] sound: Fix warnings relating to ignored return value in snd_card_register
Date: Tue, 18 Nov 2008 10:12:14 -0700
References: <154e089b0811180759x4db4ba61k467fa2275710938f@mail.gmail.com> <s5hej19dn9o.wl%tiwai@suse.de> <154e089b0811180906r69099866vf0b80cd40d7e2cc7@mail.gmail.com>
X-Mailer: Apple Mail (2.929.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 18, 2008, at 10:06 AM, Hannes Eder wrote:

> Do not ignore the return of 'device_create_file' in
> 'snd_card_register' and thereby fixing the following warnings:
>
> sound/core/init.c: In function 'snd_card_register':
> sound/core/init.c:640: warning: ignoring return value of
> 'device_create_file', declared with attribute warn_unused_result
> sound/core/init.c:641: warning: ignoring return value of
> 'device_create_file', declared with attribute warn_unused_result
>
> Signed-off-by: Hannes Eder <hannes@hanneseder.net>
> ---
>
> On Tue, Nov 18, 2008 at 11:14 AM, Takashi Iwai <tiwai@suse.de> wrote:
>> The changes look good, but please run checkpatch.pl to your patch and
>> fix the coding style issues suggested there.
>
> I did not fix:
>
> "WARNING: line over 80 characters" as they a hardly longer than 80
> characters and there are lines longer than this in the same file.
>
> "ERROR: do not use assignment in if condition" as this pattern seems
> to be quite common.
>
> Comments? Should I fix them?

I would definitely fix the ERROR, I have seen messages from Linus with  
really bad comments about using that construct. Most maintainers also  
won't want to take a patch where checkpatch reports an error. Also  
fixing the ERROR should also fix the warning.

-Richard Holden
