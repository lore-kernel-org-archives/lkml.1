Return-Path: <linux-kernel-owner+w=401wt.eu-S1752413AbZGWSQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752413AbZGWSQS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 14:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752120AbZGWSQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 14:16:17 -0400
Received: from mail-bw0-f228.google.com ([209.85.218.228]:60137 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933AbZGWSQQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 14:16:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PudAYeCVw+ta+bhWdKYqaLvR8ZuVphAIcIccmfbHO1rkmG00Mq0IJH+YeM0+p3u/E/
         xtxd1Xdgd3PY6ZaC56IXPOTx4gIbNI7eu/HH0Zkt49zHgYFiNy/MGRF7CIGg9iheq1fY
         39g2kxvyE04GqO4b/g+8+ZhEAI2rCArMcVADc=
MIME-Version: 1.0
In-Reply-To: <20090722175018.GJ2155@infomag.iguana.be>
References: <4A5F1D12.2080907@compulab.co.il>
	 <20090717084303.GA11781@centrinvest.ru>
	 <20090722175018.GJ2155@infomag.iguana.be>
Date: Thu, 23 Jul 2009 21:16:14 +0300
Message-ID: <f870da180907231116i2fc95b05ge10ff220df94f717@mail.gmail.com>
Subject: Re: SBC-FITPC2 watchdog support
From: Mike Rapoport <mike.rapoport@gmail.com>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: Denis Turischev <denis@compulab.co.il>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wim,

On Wed, Jul 22, 2009 at 8:50 PM, Wim Van Sebroeck<wim@iguana.be> wrote:
> Hi Denis,
>
>> On 197, 07 16, 2009 at 03:29:06PM +0300, Denis Turischev wrote:
>> > Adds support to watchdog timer on SBC-FITPC2 board by Compulab.
>> >
>> > Signed-off-by: Denis Turischev <denis@compulab.co.il>
>> > Signed-off-by: Mike Rapoport <mike@compulab.co.il>
>>
>> 1. please add [PATCH] to email subject next time
>> 2. patch is wordwrapped by mailer, read Documentation/email-clients.txt
>> 3. use request_region() to reserve ioport region
>> 4. you can use DMI info from you reboot quirk patch to test that you
>>    are really running on SBC-FITPC2. You'll also get module autoload
>>    as a bonus.
>
> Can you sent me the updated version for review when you are ready?

I've already did:
http://lkml.org/lkml/2009/7/21/96
If you'd like an e-mail with the patch I could send it to you next
week 'cause I don't have it handy here.


> Thanks,
> Wim.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
	Sincerely Yours,
		Mike.
