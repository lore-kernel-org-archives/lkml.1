Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752470Ab0BKIXB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 03:23:01 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:53322 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345Ab0BKIXA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 03:23:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=jGWaTgrvAvQnfryNTPz5deNA4NC0h8F/+3vn7LB459qcf72FMIY2VXQrDGhPZ8b55j
         q/Nxzm5Ap97OzNl1JhF4PeNWFI3ocgUET/V6y2J2CpHkG6OVMqLtJYHSXZYhZmr+AWuX
         +0V1Qo0r32odsDca+nPrvj2XG5+azWnm6Juyo=
MIME-Version: 1.0
In-Reply-To: <20100211072040.GB3436@ucw.cz>
References: <1265795977-20293-1-git-send-email-jochen.maes@sejo.be>
	 <20100211072040.GB3436@ucw.cz>
Date: Thu, 11 Feb 2010 10:22:58 +0200
X-Google-Sender-Auth: 519f6299e0fc9546
Message-ID: <84144f021002110022y1b3e551erb393822a80ce625d@mail.gmail.com>
Subject: Re: [PATCH 4/4] drivers: dream: Code style fix
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: Jochen Maes <jochen.maes@sejo.be>, gregkh@suse.de,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 11, 2010 at 9:20 AM, Pavel Machek <pavel@ucw.cz> wrote:
> On Wed 2010-02-10 10:59:37, Jochen Maes wrote:
>> Removed parenthesis from return statements,
>> split up assignment and if condition
>>
>> Signed-off-by: Jochen Maes <jochen.maes@sejo.be>
>> ---
>>  drivers/staging/dream/camera/s5k3e2fx.c |   22 ++++++++++++----------
>>  1 files changed, 12 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/staging/dream/camera/s5k3e2fx.c b/drivers/staging/dream/camera/s5k3e2fx.c
>> index edba198..5cb22c8 100644
>> --- a/drivers/staging/dream/camera/s5k3e2fx.c
>> +++ b/drivers/staging/dream/camera/s5k3e2fx.c
>> @@ -743,12 +743,14 @@ static int s5k3e2fx_sensor_open_init(const struct msm_camera_sensor_info *data)
>>       }
>>
>>       /* initialize AF */
>> -     if ((rc = s5k3e2fx_i2c_write_b(s5k3e2fx_client->addr,
>> -                     0x3146, 0x3A)) < 0)
>> +     rc = s5k3e2fx_i2c_write_b(s5k3e2fx_client->addr,
>> +                     0x3146, 0x3A)
>> +     if rc < 0
>>               goto init_fail1;
>
> I do not think this is valid C.

Yeah, please compile-test trivial cleanups like this before sending them.
