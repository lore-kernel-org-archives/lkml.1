Return-Path: <linux-kernel-owner+w=401wt.eu-S1753629AbZEDHmL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629AbZEDHmL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 03:42:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753108AbZEDHly
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 03:41:54 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:37253 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753203AbZEDHlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 03:41:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=W460QB9FegnNOzhlJA+vyHL788nwaBntAqOkyVJSXf0M/l8b7QVKtp0aL1wRHzJt6F
         9VCEwyFVwwC56vR6xoIkvngJeSrCqhg2m7Jvn/OTbOE8fS+H5vOfU3kHYmIcXm9I4L+R
         ubiqDFy5iE9aViLTjfBT1u90VbfLJxcG5vMY0=
MIME-Version: 1.0
In-Reply-To: <200905040002.38304.david-b@pacbell.net>
References: <3a3680030905030900x672af596mc2ebc3c38f119c92@mail.gmail.com>
	 <3a3680030905032038h40cd75bdrbee839117e5a4d55@mail.gmail.com>
	 <200905040854.03329.oliver@neukum.org>
	 <200905040002.38304.david-b@pacbell.net>
Date: Mon, 4 May 2009 10:41:51 +0300
X-Google-Sender-Auth: 7008aab4a87bb5ff
Message-ID: <84144f020905040041n721336a0t4c0f4c25eb272abf@mail.gmail.com>
Subject: Re: [PATCH] usb: use memdup_user()
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: David Brownell <david-b@pacbell.net>
Cc: Oliver Neukum <oliver@neukum.org>, Li Hong <lihong.hi@gmail.com>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Sunday 03 May 2009, Oliver Neukum wrote:
>> No. To make it plain. To me any use of memdup_user() in USB code
>> is a bad idea. I don't want to have to think about a new primitive.

On Mon, May 4, 2009 at 10:02 AM, David Brownell <david-b@pacbell.net> wrote:
> Unless it's incorrect to use that, I have to say that it
> makes more sense to use that utility than recreate it by
> open-coding...

Yup, and I don't really see how anyone can avoid "thinking about a new
primitive" anyway. We have it in the kernel now and surely it will
appear under drivers/usb/ sooner or later...

                        Pekka
