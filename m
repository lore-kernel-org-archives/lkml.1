Return-Path: <linux-kernel-owner+w=401wt.eu-S1760246AbZE1IWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760246AbZE1IWu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 04:22:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759040AbZE1IWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 04:22:34 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:1395 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757177AbZE1IWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 04:22:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Xk0zWDsriamiRP7wQOEpOuJFi3gearcrLUTy8AvtJUQB/zsYqd119PvW7PTidSMCWz
         0JpMbJUyCwWw/HP5If9gs5cZPAd1KvAhZz8oT/MTtDLU/jTJAMoB6Ox7F0LNWjSJExr8
         CWRu07OkzbkQHgkr+li1aUDHWeKMLQDwmKw/k=
MIME-Version: 1.0
In-Reply-To: <4A0BF776.9030301@compulab.co.il>
References: <63386a3d0905140129s5fd0f32cxde1114489678f012@mail.gmail.com>
	 <4A0BF776.9030301@compulab.co.il>
Date: Thu, 28 May 2009 13:52:33 +0530
Message-ID: <5d5443650905280122ha5b14a7gfd668d7ae9b09eaf@mail.gmail.com>
Subject: Re: [PATCH] MFD: Add U300 AB3100 core support v1
From: Trilok Soni <soni.trilok@gmail.com>
To: Mike Rapoport <mike@compulab.co.il>, David Brownell <david-b@pacbell.net>
Cc: Linus Walleij <linus.ml.walleij@gmail.com>, linux-kernel@vger.kernel.org,
       sameo@linux.intel.com, linux-i2c@vger.kernel.org,
       Linus Walleij <linus.walleij@stericsson.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On Thu, May 14, 2009 at 4:20 PM, Mike Rapoport <mike@compulab.co.il> wrote:
> Hi Linus,
> A few comments.
>
> Linus Walleij wrote:
>> This adds a core driver for the AB3100 mixed-signal circuit
>> found in the ST-Ericsson U300 series platforms. This driver
>> is a singleton proxy for all accesses to the AB3100
>> sub-drivers which will be merged on top of this one, RTC,
>> regulators, battery and system power control, vibrator,
>> LEDs, and an ALSA codec.
>
> As general note on the driver, you export register access methods so they can be
> called virtually anywhere.

This will apply to existing manilined driver twl4030-core driver too.
Adding David here.

read/write register APIs for twl4030-core driver is also exported
everywhere without per chip structure fed into it.

---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni
