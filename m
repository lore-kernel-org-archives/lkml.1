Return-Path: <linux-kernel-owner+w=401wt.eu-S1753447AbZDCC3P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447AbZDCC3P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 22:29:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752069AbZDCC27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 22:28:59 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:11799 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbZDCC26 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 22:28:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UhjfUNIgejsmRbxjTNQBbkzgZ0JEn07/JGF+BjtKnqTm3zAjAxkkeVaOZo4DHhB5k+
         R0Hhu2o3ybMXyYMokHP+Xefshv4PxsKcXrOIWkVoMfnuPA/BeULCq3NJBaKLsFQkG/2r
         kqWj1g5x3AlmfV8CDeiV7ddUklGbIOoxBj5lM=
MIME-Version: 1.0
In-Reply-To: <72dbd3150904021919g5405ee40p100eacb085024941@mail.gmail.com>
References: <49CCCB0A.6070701@nokia.com>
	 <alpine.DEB.2.01.0904021706330.6162@bogon.housecafe.de>
	 <9b1675090904021724t2fb0a671uc10d8e7bcba0bc5c@mail.gmail.com>
	 <9b1675090904021728y35776377u327f2266d06e2f29@mail.gmail.com>
	 <72dbd3150904021855v440f46a7oc21a7ed28fbfcb13@mail.gmail.com>
	 <9b1675090904021905o7e0cec64lfe4a5372777908b6@mail.gmail.com>
	 <72dbd3150904021919g5405ee40p100eacb085024941@mail.gmail.com>
Date: Thu, 2 Apr 2009 20:28:56 -0600
Message-ID: <9b1675090904021928k5a9948f9l8d93b6cbd5531720@mail.gmail.com>
Subject: Re: EXT4-ish "fixes" in UBIFS
From: "Trenton D. Adams" <trenton.d.adams@gmail.com>
To: David Rees <drees76@gmail.com>
Cc: Christian Kujau <lists@nerdbynature.de>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 2, 2009 at 8:19 PM, David Rees <drees76@gmail.com> wrote:
> On Thu, Apr 2, 2009 at 7:05 PM, Trenton D. Adams
> <trenton.d.adams@gmail.com> wrote:
>> On Thu, Apr 2, 2009 at 7:55 PM, David Rees <drees76@gmail.com> wrote:
>>> On Thu, Apr 2, 2009 at 5:28 PM, Trenton D. Adams
>>> <trenton.d.adams@gmail.com> wrote:
>> dirty_ratio and dirty_background never really had any affect for me.
>> I'll look into the other parameters.  Waiting for the checkout again,
>> as I am currently under a heavy rsync load (*rolls eyes*).
>
> How low have you set them?  Try setting them to 2 and 1 respectively.
> It cuts down fsync latencies by a significant amount in my experience.
>
> -Dave
>

That's the odd thing, I was setting them to 2 and 1.  I was just
looking at the 2.6.29 code, and it should have made a difference.  I
don't know what version of the kernel I was using at the time.  And,
I'm not sure if I had the 1M fsync tests in place at the time either,
to be sure about what I was testing.  It could be that I wasn't being
very scientific about it at the time.  Thanks though, that setting
makes a huge difference.
