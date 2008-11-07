Return-Path: <linux-kernel-owner+w=401wt.eu-S1753434AbYKGOhO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434AbYKGOhO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 09:37:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751912AbYKGOg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 09:36:59 -0500
Received: from wf-out-1314.google.com ([209.85.200.170]:27715 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437AbYKGOg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 09:36:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=bx9IluAQjSLAys3pYUP3jWvDCl+fAJzqfC85nBpoKwmiIGRKFq1bhxNFpE5sUg3HpA
         ZVyCGbnUI5yR3uIAXQDu5qTOONZRQmTbBvXQpbc4lWaWmNAmr3GcMzc004Qq0JJF7/7H
         GiH9rKdFxs7C0CQaZeD+v9R1W7yoYvfgVHEcI=
Message-ID: <3aaafc130811070636g681accf5qae252679c2edcdb9@mail.gmail.com>
Date: Fri, 7 Nov 2008 09:36:57 -0500
From: "J.R. Mauro" <jrm8005@gmail.com>
To: "Henrik Rydberg" <rydberg@euromail.se>
Subject: Re: [PATCH] input: Add a detailed multi-touch finger data report protocol
Cc: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <49145016.7090206@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <49142351.9080805@euromail.se>
	 <3aaafc130811070534p54eebeb6q9b57d3e847ed859a@mail.gmail.com>
	 <49145016.7090206@euromail.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 7, 2008 at 9:26 AM, Henrik Rydberg <rydberg@euromail.se> wrote:
> J.R. Mauro wrote:
>> On Fri, Nov 7, 2008 at 6:15 AM, Henrik Rydberg <rydberg@euromail.se> wrote:
>>> In order to utilize the full power of the new multi-touch devices, a
>>> way to report detailed finger data to user space is needed. This patch
>>> adds a multi-touch (MT) protocol which allows drivers to report details
>>> for an arbitrary number of fingers.
>>
>> This is a great idea, Henrik. How will things like X11 go about
>> leveraging this functionality?
>
> What I have in mind is this:
>
> 1. Add support for the MT interface in the trackpad drivers, to the extent
> they support the information. First out is bcm5974, for which the interface
> is designed. A patch is prepared, but I will keep it on hold for a little
> while longer.
>
> 2. Add support for the MT protocol in Xorg synaptics and/or a new Xorg
> multitouch driver. As you might have guessed, I have an experimental
> driver, utilizing the MT protocol. It uses proper matching techniques
> to obtain smooth multi-finger actions. My plan is to launch this in user
> space as soon as there is kernel support.
>
> Henrik
>

Have you worked with MPX? Or was a vanilla-X11 driver simple enough?
How does this all get presented to userspace applications? Multiple
mouse inputs or special stuff that applications would need a rewrite
to leverage?
