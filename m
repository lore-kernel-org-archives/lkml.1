Return-Path: <linux-kernel-owner+w=401wt.eu-S1751466AbZIYRAm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751466AbZIYRAm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 13:00:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751041AbZIYRAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 13:00:41 -0400
Received: from mail-yw0-f174.google.com ([209.85.211.174]:61390 "EHLO
	mail-yw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935AbZIYRAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 13:00:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=rgsg0p4BWnbONeEt81RRVTP2EnIlHn6JVVjHvEoXf6/c1ZX7Ru8ESZAa5i08nZNI51
         /vXAR8Vzr0bMgtNKG8cdwgvn6Sk4XmORR9B/B8Ed/AbrXZvJvCDZKNIlX1jPdjZOIFaE
         LboUfDPiTzxEZ4825WTOVRIxyKKHuzcShfi2c=
MIME-Version: 1.0
In-Reply-To: <1253888440-14111-1-git-send-email-matt@console-pimps.org>
References: <1253888440-14111-1-git-send-email-matt@console-pimps.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Fri, 25 Sep 2009 13:00:25 -0400
Message-ID: <8bd0f97a0909251000y3316891dh4d09744ed98139e8@mail.gmail.com>
Subject: Re: [PATCH] lib/checksum.c: Fix another endianess bug
To: Matt Fleming <matt@console-pimps.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 25, 2009 at 10:20, Matt Fleming wrote:
> From: Matt Fleming <matthew.fleming@imgtec.com>
>
> This fix allows the generic checksum code to work on my little endian
> system. The previous fix was not enough, as "buff" is a big-endian
> value. Without this patch I see malformed TCP packets.

can you try this one ?
http://lkml.org/lkml/2009/6/23/597
-mike
