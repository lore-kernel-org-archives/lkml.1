Return-Path: <linux-kernel-owner+w=401wt.eu-S1752641AbYKGO6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641AbYKGO6R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 09:58:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752628AbYKGO56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 09:57:58 -0500
Received: from yw-out-2324.google.com ([74.125.46.30]:5528 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449AbYKGO55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 09:57:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=p3xzHLrPz9/24dJGX8TlGe8lr1jK99C9nvbLP92J//kEoIUYL01IuHordojY9OWqn0
         yFkBd8TTz9dpjS7aezXcZeCiM6x4/QVV96wYPHYU24BUmsu1bXMFeuIaXsXp/zVk4olq
         0HBjEUsMrDMUrOCuiblO0sb1uB576a0+EvMyo=
Message-ID: <3aaafc130811070657o63894848l3c11989c9b0f2911@mail.gmail.com>
Date: Fri, 7 Nov 2008 09:57:55 -0500
From: "J.R. Mauro" <jrm8005@gmail.com>
To: "Henrik Rydberg" <rydberg@euromail.se>
Subject: Re: [PATCH] input: Add a detailed multi-touch finger data report protocol
Cc: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <49145628.7030804@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <49142351.9080805@euromail.se>
	 <3aaafc130811070534p54eebeb6q9b57d3e847ed859a@mail.gmail.com>
	 <49145016.7090206@euromail.se>
	 <3aaafc130811070636g681accf5qae252679c2edcdb9@mail.gmail.com>
	 <49145628.7030804@euromail.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 7, 2008 at 9:52 AM, Henrik Rydberg <rydberg@euromail.se> wrote:
>> Have you worked with MPX? Or was a vanilla-X11 driver simple enough?
>> How does this all get presented to userspace applications? Multiple
>> mouse inputs or special stuff that applications would need a rewrite
>> to leverage?
>
> MPX is about making use of multiple pointers. The MT protocol is about
> making use of multiple fingers. It can in principle be used as input
> to MPX applications; I will bring it up with Peter Hutterer. However,
> the main aim is to bring advanced gestures to the linux desktop.
>
> Henrik

I think this approach is cleaner than "fooling" userspace into seeing
a bunch of mice.
