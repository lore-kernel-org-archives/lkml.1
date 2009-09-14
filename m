Return-Path: <linux-kernel-owner+w=401wt.eu-S1755469AbZINMqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469AbZINMqf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 08:46:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755422AbZINMqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 08:46:34 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:46784 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755419AbZINMqd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 08:46:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=gIDbVDJqEEE4rOechsop+W90YDHK3XFrsV+nw3Vu2z3FnGf0iX6k1h02ipnEq8XGHD
         I5J2jxZ2TzCe08SPBh6P3pqP3CvJTPmRmxwtTjkqfnf5baO359RnbWWw36GYnQaiyGNb
         ixNaccMhH68fpjM3/bfhTEOxQ/5dy0rbTg47k=
MIME-Version: 1.0
In-Reply-To: <200909141438.11560.elendil@planet.nl>
References: <c64207c00909140434t46d89025yaee72908143f128c@mail.gmail.com> 
	<200909141438.11560.elendil@planet.nl>
From: Salvatore Iovene <salvatore.iovene@googlemail.com>
Date: Mon, 14 Sep 2009 15:46:10 +0300
Message-ID: <c64207c00909140546v691d17f5sfc94bf425307e037@mail.gmail.com>
Subject: Re: /lib/modules/2.6.31-10/build/drivers/input/hid-ids.h - where is 
	it?
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 14, 2009 at 3:38 PM, Frans Pop <elendil@planet.nl> wrote:
>> I have upgraded to Ubuntu 9.10 yesterday, and that brought in the
>> 2.6.31-10 kernel. I always build the linuxwacom drivers myself, and
>> they use the file in the subject (not 100% sure about the path,
>> though: I recalled it from memory).
>> Despite having all the dependencies that allowed me to build
>> linuxwacom in the past, now that file is missing.
>
> Note that when you build out-of-tree drivers you will never be guaranteed
> that your driver source will continue to build with a new kernel. When
> things break and you cannot solve the problem yourself, you should
> normally contact the organization or person where you got the driver, not
> the kernel community.

Hi, and thanks for your reply. I asked here because I thought
something might have changed into the kernel that broke linuxwacom and
they didn't know yet.

> AFAICT in this case the file was simply moved to:
> drivers/hid/hid-ids.h
>        ^^^

Actually, that's the place where the file is looked for, despite the
mistake in the subject of my email (I said I recalled from memory :))

See line 38 at http://linuxwacom.cvs.sourceforge.net/viewvc/linuxwacom/linuxwacom-dev/src/2.6.31/Makefile.in?revision=1.1&view=markup

So the question remains: why don't I have that file?
Thanks!

-- 
Salvatore Iovene
http://www.iovene.com/
http://www.geekherocomic.com/
