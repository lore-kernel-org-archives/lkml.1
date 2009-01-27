Return-Path: <linux-kernel-owner+w=401wt.eu-S1751981AbZA0Xeb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981AbZA0Xeb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 18:34:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751500AbZA0XeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 18:34:21 -0500
Received: from yw-out-2324.google.com ([74.125.46.30]:27449 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062AbZA0XeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 18:34:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=dVLJqPmC99EQ4Cv+cJD8tjHf9syDfmAI3dXkm4pjaSGTRZg7gtMYJrVTu8BkfZgsrS
         /59vZEYQ2c41QUHmEEvtitP8uRJ3OXiipH/8qiFsof96fEC6w9BMTg1wiaDSdIJgmqlX
         frCUpfdb2dem7Uuxlw2/GWxiOqyNPizEcY7xQ=
MIME-Version: 1.0
In-Reply-To: <200901260936.01501.oliver@neukum.org>
References: <e4cb19870901191220y622e0120m512596656c72bbf3@mail.gmail.com>
	 <20090125232753.db40c160.akpm@linux-foundation.org>
	 <200901260936.01501.oliver@neukum.org>
Date: Tue, 27 Jan 2009 18:34:17 -0500
X-Google-Sender-Auth: d57b230dbd92d0d5
Message-ID: <e4cb19870901271534s6385798cq60bebaf87b51c8ed@mail.gmail.com>
Subject: Re: System hang (and other problems) with cdc_acm
From: Thomas Tuttle <linux-kernel@ttuttle.net>
To: Oliver Neukum <oliver@neukum.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2009 at 3:36 AM, Oliver Neukum <oliver@neukum.org> wrote:
> Am Monday 26 January 2009 08:27:53 schrieb Andrew Morton:
> It is probably necessary to setup a watchdog. Can you do that?

I don't know how to do it, but I can follow instructions well :)

> As for the blank lines, I am not sure this is a bug. Your device may
> indeed send a lot of newlines.

It also seems to behave strangely in GPS mode.  Instead of sending
something of the form "1234567890...", it will send
1234567890...
234567890...
34567890...
and so on.  I'd like to look in to this more to see if I can write a workaround.

Cheers,

Thomas Tuttle

-- 
Thomas Tuttle
http://www.ttuttle.net/
thinkinginbinary@gmail.com
