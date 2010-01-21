Return-Path: <linux-kernel-owner+w=401wt.eu-S1752299Ab0AUCdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299Ab0AUCdP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 21:33:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751874Ab0AUCdN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 21:33:13 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:55004 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591Ab0AUCdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 21:33:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=LVYWdHU/+LUf+spO7eJg83Kmr4MedXOhg5gdQZf2AErnuVw3kNnk8Qnn1rnjpSqRVP
         NWvSPk61WLuB6I46wh1oQIpTcRbxjGpBchFQWMLfgc8Ak5riLpHFIQ056oe5CZcWpAD5
         7bwB0KlMqB7q6OIioN1nt/73A48gfduJy5eGo=
Message-ID: <4B57BCDA.1070705@gmail.com>
Date: Wed, 20 Jan 2010 23:32:58 -0300
From: "Tomas M." <tmezzadra@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091215 Shredder/3.0
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Corbin Simpson <mostawesomedude@gmail.com>,
       James Simmons <jsimmons@infradead.org>, dri-devel@lists.sourceforge.net,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Font selection with i915
References: <Pine.LNX.4.44L0.1001201504390.1672-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1001201504390.1672-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

since 2.6.32 you can change the resolution with video=VGA-1:640x480 boot 
parameter and emulate the old behaviour.



On 01/20/2010 05:39 PM, Alan Stern wrote:
> On Wed, 20 Jan 2010, Corbin Simpson wrote:
>
>    
>> FYI the legacy non-KMS path (nomodeset) is deprecated in kernel and
>> was recently dropped from the X driver. You should be able to use
>> fbset to change the resolution of your fbcon though.
>>      
> I tried fbset, and it was distinctly unsuccessful.  When I ran "fbset
> 640x480-60", the general appearance of the screen did not change but
> all new text got squeezed into the upper-left corner in an unreadable
> form.
>
> It's not clear what mode I should specify.  The output from "fbset" is
> rather unhelpful (I didn't save the exact output but this is close):
>
> 	mode: "1280x1024-0"
> 	D: 0 MHz H: 0 kHz V: 0 Hz
> 	geometry: 1280 1024 1280 1024 32
> 	timings: -1 0 0 0 0 0 0
> 	rgba: 8/16,8/8,8/0,0/0
>
> Alan Stern
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>    
