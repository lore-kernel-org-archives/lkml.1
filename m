Return-Path: <linux-kernel-owner+w=401wt.eu-S1757125AbZFDJJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757125AbZFDJJu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 05:09:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752445AbZFDJJm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 05:09:42 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:38783 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231AbZFDJJm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 05:09:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Qi82asSzVCC+0xe0Wz2gtW4WlNSQDNJBzgAma2VLYEteQgoV+9JaKGMiY/QRdMjaV0
         2WBaGztxB6wPaQWS5DDZS/lGmheKLOeqVZ5PH7jHnYGgscvs6dX6GvYxNJH3UqH1kzz+
         jBsXfemwGZ43/Sblnw1Fkt3j1g9HOgQAoJsAM=
MIME-Version: 1.0
In-Reply-To: <200906040206.44144.david-b@pacbell.net>
References: <1244017019-28163-1-git-send-email-vapier@gentoo.org>
	 <200906040127.24740.david-b@pacbell.net>
	 <8bd0f97a0906040152h1fa57f5crd96faa37322a1b40@mail.gmail.com>
	 <200906040206.44144.david-b@pacbell.net>
Date: Thu, 4 Jun 2009 05:09:43 -0400
Message-ID: <8bd0f97a0906040209r269fe700hffd0cdcba264ca0b@mail.gmail.com>
Subject: Re: [PATCH] gpio sysfs: add a "toggle" value
From: Mike Frysinger <vapier.adi@gmail.com>
To: David Brownell <david-b@pacbell.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 4, 2009 at 05:06, David Brownell wrote:
> On Thursday 04 June 2009, Mike Frysinger wrote:
>> my next request was for a 1 letter command set and chaining
>> operations.  say you want to toggle a gpio line 4 times, having to go
>> between kernel and userspace for that seems kind of heavy.
>> echo TTTT > value
>
> Having that kind of stuff in kernelspace seems wrong;
> if you're going that route, embed Guile or something.  ;)
>
> The "TTTT" thing could as easily be scripted in BASH.

the point was to lower the number of user<->kernel transitions.  yes,
all of this stuff can of course be done in the shell, but it's hard to
push limits when the interface is tying your hands and sitting on your
back.
-mike
