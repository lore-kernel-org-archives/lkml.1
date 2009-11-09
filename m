Return-Path: <linux-kernel-owner+w=401wt.eu-S1751894AbZKIRbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894AbZKIRbZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 12:31:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751470AbZKIRbV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 12:31:21 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:34093 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbZKIRbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 12:31:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=xE+td+qidmBScQvwbtLpX/LwKGkNHz2/SSTu4/XDuQxOisMdWOeLgtVZtY35whausf
         IbLk+QhiQIxZ/J1o+pvG48vfkmiV70lD3J9pVRy0XV5qCUnIeiPWlZA+G8qzIWfYimyq
         zfY1IiWBaM27ciuGLG+0GKn4jccy32ZkmZ/OM=
Message-ID: <4AF851E0.1020803@lwfinger.net>
Date: Mon, 09 Nov 2009 11:31:12 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Greg KH <gregkh@suse.de>,
       devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: remove rtl8187se driver because of lack of development
 activities
References: <200911091731.36861.bzolnier@gmail.com> <20091109145629.3587c9f6@pedra.chehab.org>
In-Reply-To: <20091109145629.3587c9f6@pedra.chehab.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2009 10:56 AM, Mauro Carvalho Chehab wrote:
> Hi Bartolomiej,
> 
> Em Mon, 9 Nov 2009 17:31:36 +0100
> Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> escreveu:
> 
>> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>> Subject: [PATCH] Staging: remove rtl8187se driver because of lack of development activities
>>
>> This driver hasn't seen any real development activities since early July:
>>
>>    257bc86   Staging: rtl8187se: remove unused #include <linu
>>    2035beb   param:remove-useless-writable-charp
>>    305409a   tree-wide: fix some typos and punctuation in com
>>    b881c6c   Staging: fix wireless drivers depends
>>    a010a33   Staging: rtl8187se/rtl8192e/rtl8192su: allow mod
>>    125b181   staging: Add proper selection of WIRELESS_EXT an
>>    b3184e1   Staging: rtl8187se: Fix comment-out-typo
>>    b6ac161   Staging: ARRAY_SIZE changes
>>
>> so remove it for now.
>>
>> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> 
> This driver has several points in common with rtl8192* drivers. As I'm
> currently working on cleaning up rtl8192u and see what can be done to merge the
> common code used by all those realtek drivers, I prefer to keep this driver for
> more time at the tree.
> 
> The issue I'm currently facing is that we should rearrange the drivers/staging/rtl* 
> into a common rtl component tree, moving the common components to there. This will
> avoid duplicated efforts to cleanup the same code several times, on different
> places.
> 
> I started working on it this weekend, but I haven't finish it yet.

As I just told Bart (off-list), I started my work on a mainline rtl8187se driver
with the rtl8180 code. There should be plenty of opportunity to set up common
code for the rtl* drivers. I will keep a close eye on your developments.

Larry
