Return-Path: <linux-kernel-owner+w=401wt.eu-S1752938AbZGTTN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938AbZGTTN6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 15:13:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751713AbZGTTNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 15:13:54 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:47119 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922AbZGTTNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 15:13:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Krx3+3b1D1WIr+mys7tv1K6tLAiwEuDz2NduX2At87rSB3SbOpY5uEZd8IXFWOOShP
         kTX5HPVw41hJo58peuYkyx2psRjg6ZXaLujHuSk9nGwd+oFMubKkdL4Ew2u5kE+Z16Tq
         3CIMdDIza4VO0p7xBxvp44zQNnLVi6G6MhAv8=
MIME-Version: 1.0
In-Reply-To: <4A648718.9000709@shipmail.org>
References: <4A647358.1040009@shipmail.org>
	 <20090720135844.GA16844@infradead.org> <4A648718.9000709@shipmail.org>
Date: Mon, 20 Jul 2009 21:13:53 +0200
X-Google-Sender-Auth: 256a56c5332c3e65
Message-ID: <6a89f9d50907201213x8e16e60s38b0a4bd929ce4ca@mail.gmail.com>
Subject: Re: DRM drivers with closed source user-space: WAS [Patch 0/3] 
	Resubmit VIA Chrome9 DRM via_chrome9 for upstream
From: Stephane Marchesin <marchesin@icps.u-strasbg.fr>
To: =?ISO-8859-1?Q?Thomas_Hellstr=F6m?= <thomas@shipmail.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       DRI <dri-devel@lists.sourceforge.net>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> You obviously got all this completely wrong.
>
> I avoid writing closed source drivers whenever I can, I'm not whining and
> I'm not trying to push any of them. The code VIA is trying to submit has not
> been written by me nor anybody I know. All VIA code I and the companies I've
> worked for has written is open-sourced and contributed to the Openchrome /
> mesa / drm project.
>
> The point I'm trying to make is the following:
>
> If the common agreement of the linux community is to *NOT* allow these
> drivers in, so be it, then be honest and go ahead and tell the driver
> writers. Don't make them respin their development trying to fix minor flaws
> when their driver won't get in anyway!
>

I would like to raise a couple of real-life issues I have in mind:

* First example, let's say VIA gets their Chrome9 DRM merged into the
kernel. Now let's say I reverse engineer the hardware (or use the docs
whenever they're available) and write a 3D component that needs
modifications to the existing DRM interface (or maybe I realize I need
a completely new DRM). Then who gets the upper hand? Do I have to keep
compatibility with user space binary modules that I do not care about?

* Second example, what is the policy if we find security holes in the
DRM for a closed user-space afterwards? This breaks the initial
promise of security, does that get the driver removed then? Or what if
the promise is pending updated documentation that never arrives?

* Third example, what if down the line we need changes in the DRM that
require updating all DRM modules. Do we (we as in DRM developers)
touch the DRM files for the VIA Chrome9 stuff, at the risk of breaking
the code (since we don't test with proprietary modules)? Or do we let
the Chrome9 files as-is, keeping the old DRM infrastructure and
therefore add more and more DRM cruft?

In my opinion, accepting GPL'ed DRM modules that support binary user
space components is like opening pandora's box.

Stephane
