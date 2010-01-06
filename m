Return-Path: <linux-kernel-owner+w=401wt.eu-S1754407Ab0AFATI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754407Ab0AFATI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 19:19:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753457Ab0AFATG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 19:19:06 -0500
Received: from qw-out-2122.google.com ([74.125.92.27]:60249 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996Ab0AFATE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 19:19:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=HTy7kZOwRTc9htnh4PewlpDR5KYCO0/8OoKv5kKl3B/SOFezcEf5S9OLbGG2zTetVh
         6BAPiJutqJQJ0edDCFJC8Z5Q+WOVWhlmwKrY2B+XTIoRHa3xgOGAlO0LMe4yKJKMZJ0P
         E2XpMp6qVcOfklHMXORQSweUJkoyXfbtR8AtU=
MIME-Version: 1.0
In-Reply-To: <20100105145931.a2c46c25.akpm@linux-foundation.org>
References: <1262015683-1711-1-git-send-email-Martin.Jansa@gmail.com> 
	<20100105145931.a2c46c25.akpm@linux-foundation.org>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Wed, 6 Jan 2010 08:18:43 +0800
Message-ID: <f17812d71001051618s1110b7d7l6377c1d0090fdbb9@mail.gmail.com>
Subject: Re: [PATCH] pxafb: fix regression from d2a34c13e7ccec5d06eafd60e6f80ea531b34668
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Martin Jansa <martin.jansa@gmail.com>, linux-kernel@vger.kernel.org,
       Julia Lawall <julia@diku.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> That patch fixes the build, but it also eliminates the test for
> fbi==NULL.  The changelog doesn't explain that change and I wonder if
> it was intentional and correct?
>
>

fbi has been well tested in pxafb_probe() and then passed to pxafb_smart_init()
and to pxafb_smart_update(), it's just unnecessary to test it again and again.
