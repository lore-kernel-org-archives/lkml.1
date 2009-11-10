Return-Path: <linux-kernel-owner+w=401wt.eu-S1751386AbZKJKah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751386AbZKJKah (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 05:30:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750912AbZKJKag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 05:30:36 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:61151 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864AbZKJKaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 05:30:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:to:cc:subject:references:from:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=xGBq9zZrrINq4L8qkI/MUPkzZWAkAZfmEdkiEd4jDC+Fgpl8++yXZKVL6bOrgCMq2b
         QUh2FUl83q/Ifb3x7TueUnBj1b4QoDEvvMZmvDt01hNRRqMZZ1OLLjmpGbxjfZSwNXC5
         cdgQuUJ02QqqctPZj9br+EQnCHT233M+zbtfU=
To: Aaro Koskinen <aaro.koskinen@nokia.com>
Cc: "linux-input\@vger.kernel.org" <linux-input@vger.kernel.org>,
       "linux-omap\@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "dmitry.torokhov\@gmail.com" <dmitry.torokhov@gmail.com>,
       "tony\@atomide.com" <tony@atomide.com>
Subject: Re: [PATCH v2 2/2] omap: RX-51: enable tsc2005
References: <1257340982-22814-1-git-send-email-aaro.koskinen@nokia.com>
	<1257340982-22814-2-git-send-email-aaro.koskinen@nokia.com>
	<87d43ufih0.fsf@purkki.valot.fi> <4AF8193A.70505@nokia.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Tue, 10 Nov 2009 12:30:37 +0200
In-Reply-To: <4AF8193A.70505@nokia.com> (Aaro Koskinen's message of "Mon\, 09 Nov 2009 15\:29\:30 +0200")
Message-ID: <87bpjaekoi.fsf@purkki.valot.fi>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aaro Koskinen <aaro.koskinen@nokia.com> writes:

>> I sent a wl1251 patch which adds spi_board_info and conflicts with
>> this patch:
>>
>> http://www.mail-archive.com/linux-omap@vger.kernel.org/msg17604.html
>>
>> How do we handle this?
>
> I can resend/rebase this patch once the wl1251 patch is integrated.

Ok, thanks. I'll resend the wl1251 patch just to be sure that it
doesn't get lost.

> BTW, check the comment from Tommi Rantala - spi_board_info can be marked
> with __initdata.

I'll add it to my patch.

-- 
Kalle Valo
