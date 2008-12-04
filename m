Return-Path: <linux-kernel-owner+w=401wt.eu-S1755557AbYLDEhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557AbYLDEhv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 23:37:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752335AbYLDEhl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 23:37:41 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:10058 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187AbYLDEhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 23:37:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=UStnomA/IjmHRAqFKWUAsfou0YFxeYnG4OQV9Y4SB4R75jGJl/BiyhZZNBP2fmWgkA
         vUynAGyb+fnC1/Tq/BxvS1LSqRcVBjUSYiyIXKQgoD21MCpmAudcTsxqHCuZefO1iFAq
         qrIT6egwXEeisZfqUbg8sOlTWTkzuhXhhSAwE=
Message-ID: <483a38b80812032037j1ba5a78ay1630e83658dabe4@mail.gmail.com>
Date: Thu, 4 Dec 2008 13:37:38 +0900
From: "Kwangwoo Lee" <kwangwoo.lee@gmail.com>
To: "Trilok Soni" <soni.trilok@gmail.com>
Subject: Re: [PATCH] Add tsc2007 based touchscreen driver.
Cc: dmitry.torokhov@gmail.com, linux-kernel@vger.kernel.org,
       "David Brownell" <david-b@pacbell.net>,
       "linux-omap@vger.kernel.org Mailing List" 
	<linux-omap@vger.kernel.org>
In-Reply-To: <5d5443650812030321p77c4941cj2202418f0b0d44a2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <483a38b80812020539v2323a784h7f202749687764db@mail.gmail.com>
	 <5d5443650812030321p77c4941cj2202418f0b0d44a2@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 3, 2008 at 8:21 PM, Trilok Soni <soni.trilok@gmail.com> wrote:
> Hi Lee
>
> Adding linux-omap mailing list. Sometime I am thinking that same chip
> might have interface to be connected on another board/cpu through SPI
> too, so in this case we will have two drivers doing the same thing and
> difference is  just a change of the bus interface.

Hi Soni,

At first, I tried to support tsc2007 with ads7846.c. But it required
some kind of
common logic to support both SPI and I2C for the driver, as you thought.

If I modified the ads7846.c to support tsc2007, the driver might be a
bit more complicate.
I do not know which method is better, but making a different driver
was simppler for me.

Thank you.

> We should do something v4l2_subdev framework right now going on on
> v4l2 mailing list to abstract the sensor drivers from bus.
>

-- 
Kwangwoo Lee <kwangwoo.lee@gmail.com>
