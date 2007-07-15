Return-Path: <linux-kernel-owner+w=401wt.eu-S932614AbXGOASy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932614AbXGOASy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 20:18:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760962AbXGOASp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 20:18:45 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:9179 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760763AbXGOASo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 20:18:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=J0Sf1dMA6O8uFMgm0ef7TTuogUhQnXtJhE2y1Pb3Dou8E4rNSyVZlbUMaaMNhH8lNLwcLd0yqdfOm81toUYtk4ysFYdXYV8mzanr3W390Uh/ydLW6gb52+D173+ZRMCEULzKqPa6W5bwY6Rlc4NodtPZYjq+k0XnZBvO9ME6yJ4=
Message-ID: <9c21eeae0707141718r16de38a7rac80458c168b5f05@mail.gmail.com>
Date: Sat, 14 Jul 2007 17:18:39 -0700
From: "David Brown" <dmlb2000@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: dm-crypt aes sha512 and I/O performance
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I was forced to put full (almost) hard drive encryption on my laptop
so that all the Open Source Work I get paid to do will be protected in
case someone tries to steal it and so they won't find any personal
information about me if they get a hold of my laptop (because every
idiot keeps their entire life history on their computers).

Besides the futility of the above statement I've been noticing some
oddities with how linux and dm-crypt handles I/O on the system.

Now normally I get about 30Mb/s write speed I would expect some sort
of drop in performance due to the encryption but currently I'm getting
about 9Mb/s write speed and I'm kinda confused as to what the choke
point is and how to improve the write speed, if it can be.

Currently both my swap and root are encrypted with the default debian
installer encryption and there's two kcryptd processes running. Now
from what I've noticed when I'm dumping data to disk they both seem to
be working, yet I'm not swapping or anything. So am I right to assume
that the two kcryptd processes are running in parallel encrypting the
data to the one root device? Also they only seem to be using 20% of
the processors they are running on, why isn't it 100%? I'm guessing
that the data isn't being either compressed or blown up when
encrypting using this encryption style (but I'm not an expert). Would
making more kcryptd threads increase the I/O speed (more processes
doing encrypting)? Is there a way to specify more threads of kcryptd?

I'm kinda at a loss, so any help would be appreciated.
- David Brown
