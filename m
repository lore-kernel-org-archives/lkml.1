Return-Path: <linux-kernel-owner+w=401wt.eu-S1758220AbZBYTKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758220AbZBYTKg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 14:10:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756017AbZBYTK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 14:10:28 -0500
Received: from smtp21.orange.fr ([80.12.242.46]:30368 "EHLO smtp21.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755950AbZBYTK2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 14:10:28 -0500
X-ME-UUID: 20090225191024863.D2CC51C0008B@mwinf2101.orange.fr
Message-ID: <49A59799.6050301@free.fr>
Date: Wed, 25 Feb 2009 20:10:17 +0100
From: Eric Valette <eric.valette@free.fr>
Reply-To: eric.valette@free.fr
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Some user feedback on recent Intel chipset and 2.6.29 KMS
References: <49A51B4D.5070903@Free.fr> <21d7e9970902250237i13f20336ib0176ed2b0edd7f4@mail.gmail.com> <49A52555.8070404@Free.fr>
In-Reply-To: <49A52555.8070404@Free.fr>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Valette wrote:
> Dave Airlie wrote:
>> See if the attached patch helps resume, there are also some other patches
>> queued for Linus in my drm-fixes tree. I sent the pull req earlier.
>>   
> 
> Thanks for the quick anwser.
> 
> I will test the individual patch as soon as I get back home and report.

NB: the patch by itself missed an include for the prototype of the new
function called on resume.

Once I included the relevant drm include file it greatly improved resume
behavior: I managed to suspend at least once which has been impossible
for months (as soon as I entered an endless "catch up run" (fuite en
avant in french) due to a debian experimental libdrm package upgrade)).
However, it froze at second attempt.

> For the earlier pull, I will probably wait until its available in a
> 2.6.29-rc6-gitx and report. Do you want separate reports or testing the
> whole stuff?

I saw Linus integrated it so probably tomorrow...

Of course the "refresh" problem is still there as the patch is only for
resume path...

-- eric


