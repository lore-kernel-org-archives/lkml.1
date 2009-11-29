Return-Path: <linux-kernel-owner+w=401wt.eu-S1752660AbZK2Rhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660AbZK2Rhc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 12:37:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752276AbZK2Rhc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 12:37:32 -0500
Received: from mail-qy0-f194.google.com ([209.85.221.194]:39655 "EHLO
	mail-qy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724AbZK2Rhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 12:37:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=jc7CctlqpVdCVqQ4H851YS+sJIc9VFM9nQsbGiEYIlC6Pg9sEvwNivWgWYdPGG01Oe
         UOTwjodiLQyzse0AG5bzYeX1ncCriL7tGqhjqly1PlwuilxOa4NFmR7eOgJi/g4ZOh0s
         DUrPSLaZ6/AFWxJsMlQ4hbEMtiUZgbU8WbNJI=
MIME-Version: 1.0
In-Reply-To: <20091129171437.GA4993@kroah.com>
References: <20091127013217.7671.32355.stgit@terra>
	 <20091127013423.7671.36546.stgit@terra>
	 <20091129171437.GA4993@kroah.com>
Date: Sun, 29 Nov 2009 12:37:36 -0500
Message-ID: <9e4733910911290937v7795da49q613c172b2cc9d13c@mail.gmail.com>
Subject: Re: [IR-RFC PATCH v4 2/6] Core IR module
From: Jon Smirl <jonsmirl@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 29, 2009 at 12:14 PM, Greg KH <greg@kroah.com> wrote:
> On Thu, Nov 26, 2009 at 08:34:23PM -0500, Jon Smirl wrote:
>> Changes to core input subsystem to allow send and receive of IR messages. Encode and decode state machines are provided for common IR porotocols such as Sony, JVC, NEC, Philips, etc.
>>
>> Received IR messages generate event in the input queue.
>> IR messages are sent using an input IOCTL.
>
> As you are creating new sysfs files here, please document them in
> Documentation/ABI/

This code is not going to get merged as is. It's just a starting point
to get a discussion started about designing an IR subsystem. I expect
the final design will look a lot different.

I'm trying to demonstrate that IR is an input device and that it can
be supported by the Linux input subsystem without the need to create a
special IR device.

-- 
Jon Smirl
jonsmirl@gmail.com
