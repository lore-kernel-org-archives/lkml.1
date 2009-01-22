Return-Path: <linux-kernel-owner+w=401wt.eu-S1756622AbZAVC0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622AbZAVC0T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 21:26:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755413AbZAVC0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 21:26:07 -0500
Received: from yw-out-2324.google.com ([74.125.46.28]:41803 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754928AbZAVC0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 21:26:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=XdeXUor6qHOG6SQt6kJV6BTUKrcPOEowYBzVLkk6f09FRqJZiPmCosyjYTZQddwTWN
         j2mXOB1+1gY2I0dmlQdS8FKbSGasC7rP4O4Ju6LF7e/Oon/VZgi4C+RJx9i7u5axaerr
         H4pKD/WXiWfHEjTIme0Zd7gvWzw7iLNgJ+d0g=
MIME-Version: 1.0
In-Reply-To: <4977BFFE.3040305@zytor.com>
References: <3aa654a40901190604l2149c592ne4fbf782fa46655f@mail.gmail.com>
	 <4977BFFE.3040305@zytor.com>
Date: Wed, 21 Jan 2009 18:26:03 -0800
Message-ID: <3aa654a40901211826s430487c1i882fb5c4b8fa92a9@mail.gmail.com>
Subject: Re: Fail to early boot with v2.6.27-rc2 to at least v2.6.29-rc2 due 
	to dc1e35c
From: Avuton Olrich <avuton@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2009 at 4:38 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Avuton Olrich wrote:
>>
>> Hello,
>>
>> My computer fails to make it past 'Unpacking kernel' with anything
>> later than dc1e35, to at least v2.6.29-rc2 due to dc1e35c, at least so
>> git bisect told me. While writing this bug I discovered I was using
>> gcc-4.1.1 when I thought I was using gcc-4.3.2; I upgraded, recompiled
>> 2.6.28.1 and same results so I assume the same results would come from
>> me doing the 4 hour bisect again.
>>
>
> Hi Avuton,
>
> Could you apply these two patches and verify that they work, even with the
> BIOS CPUID level limit enabled?

Worked perfect, again thanks!
-- 
avuton
--
|  (\_/)  This is Bunny. Copy and paste Bunny
| (='.'=) into your signature to help him gain
| (")_(") world domination.
