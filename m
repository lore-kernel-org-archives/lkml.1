Return-Path: <linux-kernel-owner+w=401wt.eu-S1754917AbYKLXLw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917AbYKLXLw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 18:11:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751608AbYKLXLo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 18:11:44 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:61073 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbYKLXLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 18:11:43 -0500
Date: 13 Nov 2008 00:09:00 +0100
From: lirc@bartelmus.de (Christoph Bartelmus)
To: linux-kernel@vger.kernel.org
Cc: jonsmirl@gmail.com
Cc: jrm8005@gmail.com
Message-ID: <ApnRmVyojFB@christoph>
In-Reply-To: <7f0c6fc9-556c-41a1-9750-ffb3455589ab@35g2000pry.googlegroups.com>
Subject: Re: In-kernel IR remote control support
User-Agent: OpenXP/4.10.7369 (Linux) (i386)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX1+19vO9+ehfRbwVSBOSuYqcW4vpjGfgsE8GxUW
 GD6jUZIqWAPoJITtpbGOwBq6oTn5SEOoFPcAAQS2OL7wCsqtFi
 LhtYQIvjj8Z3IZq6lYQ+UH8xPh8ZqjbME6X/ij1ysI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

on 12 Nov 08 at 14:39, J.R. Mauro wrote:
[...]
> On Wed, Nov 5, 2008 at 3:07 PM, Jon Smirl <jonsm...@gmail.com> wrote:
>> On Wed, Nov 5, 2008 at 2:59 PM, J.R. Mauro <jrm8...@gmail.com> wrote:
>>> On Wed, Nov 5, 2008 at 2:47 PM, Jon Smirl <jonsm...@gmail.com> wrote:
>>>> New release of in-kernel IR support implementing evdev support. The goal
>>>> of in-kernel IR is to integrate IR events into the evdev input event
>>>> queue and maintain ordering of events from all input devices. Still
>>>> looking for help with this project.

>>> (Forgive me if this has already been asked or dealt with)

>>> Have you contacted the LIRC developers? Is there any overlap between
>>> your projects?

>> The LIRC people know about this. Pieces of the code are coming from
>> the LIRC source base and being reworked for kernel inclusion.

> Great, it's nice to see there's cooperation.

LOL. There's just a small omission from Jon's side...
Yes, LIRC people know about this. And Jon has a no-go from me.

Decoding IR protocols in-kernel is the wrong way IMHO and this will not be  
supported by LIRC as long as I maintain LIRC.
It's simply not possible to decode all existing IR protocols and LIRC just  
stores the timing data for these protocols as-is without trying to decode  
them. With the in-kernel decoding approach these remotes cannot be  
supported. I'm not willing to sacrifice the support for these even though  
they only consist of a very small fraction of remotes in use.

Christoph
