Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757193Ab0BLBtu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 20:49:50 -0500
Received: from mail-iw0-f201.google.com ([209.85.223.201]:63927 "EHLO
	mail-iw0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755877Ab0BLBtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 20:49:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=un0OAaSC8f/J05+ha+8Pb7BTQbcejb6xay7WbU0IPwowqdMaytgEjb6AczHI8k3RIi
         Y6qFuAUwU+SrhF31YtWeCZXeYPhFgY0rGHlp+6JxNt55mN0CvRvjzR32s1LmrRcl1/+b
         b1LIF7csB5TWJI2OjXHTEg9VJ0xfGYHJ3vdaU=
MIME-Version: 1.0
In-Reply-To: <201002112354.51990.st@iss.tu-darmstadt.de>
References: <201002092306.07449.st@iss.tu-darmstadt.de>
	 <4B7354D9.50909@gmail.com> <201002112354.51990.st@iss.tu-darmstadt.de>
Date: Thu, 11 Feb 2010 19:49:48 -0600
Message-ID: <51f3faa71002111749k403df397j8b3c924ad9cf633e@mail.gmail.com>
Subject: Re: 2.6.33-rc7 problems
From: Robert Hancock <hancockrwd@gmail.com>
To: ST <st@iss.tu-darmstadt.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 11, 2010 at 4:54 PM, ST <st@iss.tu-darmstadt.de> wrote:
> Hi
>> Well, the card reader apparently reports medium not present.. is there
>> anything in there? how is it not working?
> Just another information: It seems as if *only* the SD Card component of
> the reader is detected. This explains why there are only no medium present
> results in the calls. There was no SD card plugged into the usb-reader. The
> others like CF,Xd,MS are not detected as it seems, while the SD Card component
> is indeed working as expected and seen in the log.

It looks like this device is like a lot of other multi card-readers in
that it actually is 4 separate logical units (one for SD/MMC, one for
CF, one for SM/xD and one for MS). Each of them operates
independently, which is why you get (or should get) 4 separate drives
showing up. I'm still not sure what you're saying the problem is
though - you're not getting all of the drives detected? Can you post
the full dmesg from 2.6.32 when connecting the drive?
