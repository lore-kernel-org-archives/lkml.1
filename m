Return-Path: <linux-kernel-owner+w=401wt.eu-S1757353AbYJ3QlF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757353AbYJ3QlF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 12:41:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757181AbYJ3Qkr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 12:40:47 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:61220 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757168AbYJ3Qkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 12:40:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=wBBlw2ZnvuXEnSd3UUQOr+oJNb4XjF/Lon+WX2JwKIHNO75JSkn5s4o6OlBd7IpYRo
         dQH30tGoB7BhTk5eKdNmG/ZYKReo075Kl8yadtY5tFRjwHHBPU7HaGLeGZB0rYbhvSdD
         nG9xhRLaZ2xo0hJeNDY0fH7+3xE9DdlF1N4cI=
Message-ID: <9e4733910810300940w22786f2ate63cc828c1e66f9d@mail.gmail.com>
Date: Thu, 30 Oct 2008 12:40:44 -0400
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Jonas Bonn" <jonas.bonn@gmail.com>
Subject: Re: [RFC] API for system clocks (oscillators)
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <9e4733910810300939x40a7afear7a49557604ced628@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <7a6abd110810300741wf73f838laa3754e23c22baf3@mail.gmail.com>
	 <9e4733910810300840v7cd45c2cu629d23a27a02c61a@mail.gmail.com>
	 <7a6abd110810300927l428b11f3u509ad31364c08f1f@mail.gmail.com>
	 <9e4733910810300939x40a7afear7a49557604ced628@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2008 at 12:39 PM, Jon Smirl <jonsmirl@gmail.com> wrote:
> On Thu, Oct 30, 2008 at 12:27 PM, Jonas Bonn <jonas.bonn@gmail.com> wrote:
>>>
>>> How does this compare to the framework in linux/include/linux/clk.h?
>>>
>>
>> clk.h is pretty much just an infrastructure for "storing" clock data
>> and accessors... it does not provide:
>>
>> i) Constraints on selectable frequencies of active devices
>> ii) Notifiers on frequency change, including changes due to events
>> such as reparenting
>>
>> These are the big ones that cause headaches.  When I want to switch
>> frequency, I have to check elsewhere which devices are active and
>> which frequencies they allow.  When a frequency changes, I have to
>> manually make sure that the active devices are notified properly of
>> the change.  These are the main things that my document tries to
>> consolidate into one framework.  Like I said, I'm not sure it's the
>> right approach, that's why I requested feedback...
>
> You could probably work those features into the existing clk framework.
> clk_set_rate() could compute the constrains and return an error.
> The API could be expanded with notifier support.

BTW, most user of the clk framework are on ARM.

>
> --
> Jon Smirl
> jonsmirl@gmail.com
>



-- 
Jon Smirl
jonsmirl@gmail.com
