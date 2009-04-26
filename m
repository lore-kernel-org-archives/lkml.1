Return-Path: <linux-kernel-owner+w=401wt.eu-S1755112AbZDZONv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755112AbZDZONv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 10:13:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753792AbZDZONj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 10:13:39 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:45956 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120AbZDZONh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 10:13:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xbR7jCinF8LtMdte7uuKhSAp+8a6Gab/5br8oeY5omLMIiFYDKkw19eU3yw5GZ8G3S
         pe4mLSaH77ohQwb4I9dAt1ojDeHQ6pHN8z512Owq+l9vebH/GufY7AOdwgH0ObA02Kkh
         IyYG1bnNxffiR5CRKTFaaav9l6q8CPu88RrNY=
MIME-Version: 1.0
In-Reply-To: <49F43975.2060106@gmail.com>
References: <1240661363-16631-1-git-send-email-jirislaby@gmail.com>
	 <20090426020047.GA10885@hash.localnet> <49F43975.2060106@gmail.com>
Date: Sun, 26 Apr 2009 17:13:35 +0300
Message-ID: <40f31dec0904260713o97f5cs95f87d72e8772e64@mail.gmail.com>
Subject: Re: [PATCH 1/1] ath5k: 5211, don't crypt every protected frame
From: Nick Kossifidis <mickflemm@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Bob Copeland <me@bobcopeland.com>, linville@tuxdriver.com,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/4/26 Jiri Slaby <jirislaby@gmail.com>:
> On 04/26/2009 04:00 AM, Bob Copeland wrote:
>> On Sat, Apr 25, 2009 at 02:09:23PM +0200, Jiri Slaby wrote:
>>> Hi guys,
>>> do you remember some 5211 HW which didn't work with this?
>>> --
>>>
>>> Set null key type even on ar5211, otherwise it en/decrypts every frame with
>>> protected bit set which renders the card unusable on encrypted networks.
>>
>> Not me.  I don't have the hardware, so I would say if your patch is known
>> to work on a 5211 then we go with it.
>
> Ok, thanks. Of course the HW I used (IBM T40 Thinkpad) needs the patch ;).
>

Acked-by: Nick Kossifidis <mickflemm@gmail.com>

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
