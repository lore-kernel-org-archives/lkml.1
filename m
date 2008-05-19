Return-Path: <linux-kernel-owner+w=401wt.eu-S1758221AbYESIGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758221AbYESIGT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 04:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755101AbYESIGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 04:06:00 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:9713 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758113AbYESIF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 04:05:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Iv1UU8qFfE5QYE3zTpCm3kdLCK+zz+a53C53PpicBbwmvqaOm9Ei/f1EFGU3mm6YTGmm4CzW+YD9USOuZbQNhrymAc0tnkV01EgCGF946jqNdALsAHk6XFGNSrbW8Y0YvOPYbw8VcWQZdTvm9zRH40/I0X3mbkrKM8A/dRoliAw=
Message-ID: <386072610805190105y6618dd9bwe32503c1ae11b865@mail.gmail.com>
Date: Mon, 19 May 2008 16:05:56 +0800
From: "Bryan Wu" <cooloney@kernel.org>
To: "Felipe Balbi" <me@felipebalbi.com>
Subject: Re: [PATCH 0/2] MUSB: 2 patches to fix some bug found on Blackfin
Cc: "David Brownell" <david-b@pacbell.net>, tony@atomide.com,
       linux-omap@vger.kernel.org, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <71636ee466dd53c366eb11d8fc981e8b@felipebalbi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1211022081-27298-1-git-send-email-cooloney@kernel.org>
	 <200805170737.37806.david-b@pacbell.net>
	 <386072610805182339n2e141b83q4b8f9804194088e4@mail.gmail.com>
	 <71636ee466dd53c366eb11d8fc981e8b@felipebalbi.com>
X-Google-Sender-Auth: 2c3aab56c9756525
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2008 at 3:49 PM, Felipe Balbi <me@felipebalbi.com> wrote:
>
>
> On Mon, 19 May 2008 14:39:10 +0800, "Bryan Wu" <cooloney@kernel.org> wrote:
>> On Sat, May 17, 2008 at 10:37 PM, David Brownell <david-b@pacbell.net>
>> wrote:
>>> On Saturday 17 May 2008, Bryan Wu wrote:
>>>>
>>>> We discussed these 4 bugs before. Now we fixed them.
>>>> Please review following 2 patches.
>>>
>>> They looked plausible to me ... though the urb->status
>>> one is a bit of a band-aid, and when that field finally
>>> vanishes a better fix will be needed.
>>>
>>
>> OK, so is there any plan for merge the MUSB to mainline and finally to
>> remove the urb->status?
>
> I was planing to do this by the end of this year or as soon as I make all
> usb if tests pass again. I'm out of tools for that right now :-s
>

Great, after I enable the DMA mode 1 on Blackfin and cleanup the code,
I will send
out the code before you sent them to upstream

Thanks
-Bryan
