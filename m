Return-Path: <linux-kernel-owner+w=401wt.eu-S1753862Ab0AKTll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862Ab0AKTll (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 14:41:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753895Ab0AKTli
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 14:41:38 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:53892 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753862Ab0AKTlh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 14:41:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=UXZOa0Uf0hZ2NMEdOF9qQv+SFzhZ0i6ikWF152MbNY4sRiGyRxhf3wbsmksQtE96w4
         tnsJn+0O7YgtHYTrUT1Sxz9Cc+EsR2cA+pUD5NrhU6W2owdWhwwQOFkBS6z1X1NUCqvi
         yRO3xxdxeKm1OeS20ZieOhSoSdxrHN2kvZmoc=
MIME-Version: 1.0
In-Reply-To: <5543f88f1001111129u362be554kd97027d977b5dff3@mail.gmail.com>
References: <5543f88f1001111129u362be554kd97027d977b5dff3@mail.gmail.com>
Date: Mon, 11 Jan 2010 11:41:35 -0800
X-Google-Sender-Auth: 5b4cbce70bb911cf
Message-ID: <5543f88f1001111141r5375d2a3kd726d2b70e124b94@mail.gmail.com>
Subject: Re: [PATCH]drivers/ata/libata-eh.c:1509 unneeded memset()
From: Marc Bejarano <beej@beej.org>
To: =?ISO-8859-1?Q?Ren=E9_Bolldorf?= <xsecute@googlemail.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       James Bottomley <James.Bottomley@suse.de>, linux-kernel@vger.kernel.org,
       jgarzik@pobox.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

and once more in plain text.  (sorry vger)

2010/1/11 Marc Bejarano <beej@beej.org>:
> oops.  seems that GMANE's reply function only goes to a single "newsgroup".
>  original recipients re-added.
> marc
> ----
> From: Marc Bejarano <beej <at> beej.org>
> Subject: Re: [PATCH]drivers/ata/libata-eh.c:1509 unneeded memset()
> Newsgroups: gmane.linux.scsi
> Date: 2010-01-08 22:21:09 GMT (2 days, 20 hours and 40 minutes ago)
>
> René Bolldorf <xsecute <at> googlemail.com> writes:
>> On 01/08/10 16:28, James Bottomley wrote:
>> > On Thu, 2010-01-07 at 14:15 -0500, Jeff Garzik wrote:
>> >> On 12/30/2009 05:59 PM, René Bolldorf wrote:
>> >>> We don't need this .
>
>> >>> - /* FIXME: is this needed? */
>> >>> - memset(sense_buf, 0, SCSI_SENSE_BUFFERSIZE);
>> >>
>> >> I need a little bit more detail than an unqualified statement...  Did
>> >> you audit all paths leading to this code point?
>
>> > But one also here:
>> >
>> > u8 *sense_buffer = dev->link->ap->sector_buf;
>> > [...]
>> > err_mask = atapi_eh_request_sense(dev, sense_buffer, sense_key);
>> >
>> > Which doesn't look OK because it looks like the sector_buf isn't cleared
>> > (and it is reused).
>> >
>> > James
>> >
>> >
>>
>> Thank's, you're right. I have overseen this, sry for that.
>
> René: perhaps you'd like to submit a patch that substitutes FIXME comment
> for one that explains why the memset is needed, crediting James in the
> description?  we may as well gain something permanent from this discussion
> that you started :)
>
> cheers,
> marc
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo <at> vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> ----
