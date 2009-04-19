Return-Path: <linux-kernel-owner+w=401wt.eu-S1757311AbZDSSXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757311AbZDSSXm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 14:23:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755184AbZDSSXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 14:23:33 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:23777 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948AbZDSSXc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 14:23:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=BYZ2TZbDaFmFLf0llkcsuhgKOHJCvJCnEjbOK76kcEhv7ye0VBoqaI7QLkquozQHPg
         9+1uatrKvmFHVf+qmHsJDLQLCAbDgRJmPXmYEkgnHtr1K67CyyBLWNGw8O4m/soFwLy4
         X5TpJvocDpPmkw+MRJ4F/nAMYNU67LAbNqu9I=
MIME-Version: 1.0
In-Reply-To: <20090418232533.GB23201@kroah.com>
References: <1240080744-14995-1-git-send-email-geert@linux-m68k.org>
	 <1240080744-14995-2-git-send-email-geert@linux-m68k.org>
	 <20090418232533.GB23201@kroah.com>
Date: Sun, 19 Apr 2009 20:23:30 +0200
X-Google-Sender-Auth: 88dc56cabf7e7cc9
Message-ID: <10f740e80904191123w64e951beya329e4e91aa7765@mail.gmail.com>
Subject: Re: [PATCH/RFC 01/16] platform: Make platform resources input 
	parameters const
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg KH <greg@kroah.com>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 19, 2009 at 01:25, Greg KH <greg@kroah.com> wrote:
> On Sat, Apr 18, 2009 at 08:52:09PM +0200, Geert Uytterhoeven wrote:
>> Make the platform resources input parameters of platform_device_add_resources()
>> and platform_device_register_simple() const, as the resources are copied and
>> never modified.
>>
>> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
>> Cc: Greg Kroah-Hartman <gregkh@suse.de>
>
> If you need this for your other patches, no objection from me, feel free

Yes, my other patches depend on it.

> to take it through your tree (or I can take it through mine if you
> want.)

OK, will take it. Thanks!

> Either way, feel free to add:
>        Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
>
> to it.

Acked-by, I assume...

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
