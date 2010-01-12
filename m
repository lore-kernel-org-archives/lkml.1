Return-Path: <linux-kernel-owner+w=401wt.eu-S1754578Ab0ALAzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578Ab0ALAzt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 19:55:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753308Ab0ALAzs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 19:55:48 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:41411 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202Ab0ALAzr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 19:55:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=RXMjtxgTJaPDBED2OCKOnTp8JAWd/6LD2erSTXuGMNyGNMyD+DBUmJGhtiXAnd0iQ5
         mXyszftIjuy60jEc8USEoFY47kww00kzGdmEbYR3R3CvwGfm5+tr9NFn+R1hEEL7jf0T
         rFXlbCgqg+xF8xbZMNFl46VIiaUcUBQ3bfB+c=
MIME-Version: 1.0
In-Reply-To: <4B4B877A.8060106@googlemail.com>
References: <5543f88f1001111129u362be554kd97027d977b5dff3@mail.gmail.com>
	 <5543f88f1001111141r5375d2a3kd726d2b70e124b94@mail.gmail.com>
	 <4B4B877A.8060106@googlemail.com>
Date: Mon, 11 Jan 2010 16:55:45 -0800
X-Google-Sender-Auth: d9045f46a0460882
Message-ID: <5543f88f1001111655t7ae4a4eamd4f010b5ab7e7c82@mail.gmail.com>
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

2010/1/11 René Bolldorf <xsecute@googlemail.com>:
> I hope that's good enough explained :-).

definitely an improvement, but i think jeff is going to want your
S-O-B and at least a patch title, if no description :)


> +       /* make sure sense_buf is cleared then atapi_eh_request_sense is
> called.

s/then/when/ ?

> +        * (to make sure nothing get's reused.)

probably not necessary

> +        * thanks to James Bottomley

this may be better in a patch description

cheers,
marc
