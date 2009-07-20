Return-Path: <linux-kernel-owner+w=401wt.eu-S1754245AbZGTWb6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245AbZGTWb6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 18:31:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753821AbZGTWb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 18:31:56 -0400
Received: from mail-gx0-f213.google.com ([209.85.217.213]:37114 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754051AbZGTWb4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 18:31:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KCT8Z3tazSvjHMSdthmrzB3n+EnIB8uFi/XXpSUJstjzgenFV5R4sIhNUiIUcY+RMX
         aUKq+qMm+NjuRmUEB3p6BmmdNIbd3h2x5NqGA/zVfiq/an7dtcq5f5LK7c54jr14w4J8
         /HlU7RjVNYl4uNkiAjdgmoJbFMExN/sf0ccik=
MIME-Version: 1.0
In-Reply-To: <6a89f9d50907201440w534e1645q4d3d067c198090eb@mail.gmail.com>
References: <4A647358.1040009@shipmail.org>
	 <20090720135844.GA16844@infradead.org> <4A648718.9000709@shipmail.org>
	 <6a89f9d50907201213x8e16e60s38b0a4bd929ce4ca@mail.gmail.com>
	 <4A64D16E.90903@shipmail.org>
	 <6a89f9d50907201440w534e1645q4d3d067c198090eb@mail.gmail.com>
Date: Tue, 21 Jul 2009 08:31:55 +1000
Message-ID: <21d7e9970907201531s45a55493od827034a0f26f4c8@mail.gmail.com>
Subject: Re: DRM drivers with closed source user-space: WAS [Patch 0/3] 
	Resubmit VIA Chrome9 DRM via_chrome9 for upstream
From: Dave Airlie <airlied@gmail.com>
To: Stephane Marchesin <marchesin@icps.u-strasbg.fr>
Cc: =?ISO-8859-1?Q?Thomas_Hellstr=F6m?= <thomas@shipmail.org>,
       Christoph Hellwig <hch@infradead.org>,
       DRI <dri-devel@lists.sourceforge.net>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/7/21 Stephane Marchesin <marchesin@icps.u-strasbg.fr>:
> 2009/7/20 Thomas Hellström <thomas@shipmail.org>:
>>
>> Stephane,
>> Some comments on how these things has been handled / could be handled.
>>>
>>> I would like to raise a couple of real-life issues I have in mind:
>>>
>>> * First example, let's say VIA gets their Chrome9 DRM merged into the
>>> kernel. Now let's say I reverse engineer the hardware (or use the docs
>>> whenever they're available) and write a 3D component that needs
>>> modifications to the existing DRM interface (or maybe I realize I need
>>> a completely new DRM). Then who gets the upper hand? Do I have to keep
>>> compatibility with user space binary modules that I do not care about?
>>>
>>
>> If there is a serious OS project, I'd start a new DRM driver.
>> That's sort of what may happen with openChrome vs via..
>>
>
> Well, for user space, there can be as many drivers as you want for a
> given device. But the DRM policy always was one driver per hardware so
> as to avoid confusing people, so what you're proposing is in fact not
> possible. In that case, this would even deter a fully open source
> driver as it would have to keep the same interface as some (possibly
> unsupported) driver.

Well with KMS it sort of changes that a small bit, since a KMS driver really
isn't required to share old interfaces, since having a KMS enabled
kernel will break any
userspace that is out there just by setting up the hw different. as
long as the old
code is still available in the backwards compat manner it should all be fine.

We've also had two drm drivers before, i830 and i915 supported a lot
of the same hw
and it mostly worked, if you looked at it from a kernel perspective.

Dave.
