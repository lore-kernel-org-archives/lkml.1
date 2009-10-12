Return-Path: <linux-kernel-owner+w=401wt.eu-S932137AbZJLNqH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932137AbZJLNqH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 09:46:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756596AbZJLNqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 09:46:07 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:63134 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755385AbZJLNqF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 09:46:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SNkyxEW/gZuWbGZb29HNyD+CuyqK6+rgYuahH5xvaJPYrs+33KQ8fGy6++9hoxUzOs
         JqMDzLnygApdrEDWa7wnCqYa9mIjesFYjvKGXZlWsrtgcpbbmppfi1qJHy/Gq9oAfabF
         o7ymaPSH2sxbfjbNCllaQfaKpoATiLWtdZRks=
MIME-Version: 1.0
In-Reply-To: <9c9fda240910111732x262a9510rf3dd862aa16d0bdf@mail.gmail.com>
References: <20091006074533.GA28889@july> <20091011090549.GE1414@ucw.cz>
	 <9c9fda240910111732x262a9510rf3dd862aa16d0bdf@mail.gmail.com>
Date: Mon, 12 Oct 2009 19:14:57 +0530
Message-ID: <5d5443650910120644x4180ff6bt45b72be86b50588f@mail.gmail.com>
Subject: Re: [PATCH] Haptic class support (v2)
From: Trilok Soni <soni.trilok@gmail.com>
To: Kyungmin Park <kmpark@infradead.org>
Cc: Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org, Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kyungmin,

On Mon, Oct 12, 2009 at 6:02 AM, Kyungmin Park <kmpark@infradead.org> wrote:
> On Sun, Oct 11, 2009 at 6:05 PM, Pavel Machek <pavel@ucw.cz> wrote:
>> On Tue 2009-10-06 16:45:33, Kyungmin Park wrote:
>>> This patch includes two haptic devices, isa1000 and isa1200
>>> ISA1000 is gpio based haptic, but isa1200 is based on I2C
>>> Both are working on Samsung SoCs and tested.
>>>
>>> To enable the haptic, echo 1 > /sys/class/haptic/${name}/enable
>>> You can adjust the level by echo ${level} > /sys/class/haptic/${name}/enable
>>> or
>>> With oneshot feature, echo ${msec time} > /sys/class/haptic/${name}/oneshot
>>
>> New device classes should certainly be documented in Documentation/.
>>
>> For example... is level 0-100?
>
> Basically. range from 0 to 255. also each device can set max level in
> case of isa1000 it's 6.
>
>>  Is it valid to change level while 'oneshot' is running?
>
> we usually use it under 1 sec. but I think it's possible to change it
> but not tried.
>
>>  Does oneshot use last level set?
>
> Right. it used last set value.
>
> If you don't mind to update these at Documentation please wait until
> commit first patches merged.

Let's see what Greg prefers. Could you please refresh your patchset
with probably addressing comments given in the isa1200 and samsung_pwm
driver by me?

-- 
---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni
