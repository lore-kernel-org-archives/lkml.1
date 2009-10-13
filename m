Return-Path: <linux-kernel-owner+w=401wt.eu-S1759473AbZJMLOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759473AbZJMLOX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 07:14:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752175AbZJMLOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 07:14:22 -0400
Received: from mail-qy0-f186.google.com ([209.85.221.186]:54958 "EHLO
	mail-qy0-f186.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbZJMLOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 07:14:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Ck9+j6v1bw6wm0VjllbXzPnfR7Dmt+6/PdMmF0zmvMHgcrdNpHWe/46ypuEj5CBipo
         Y72YB7tgVFSwx9y3vYpIBUt70jtHvjPVh01jPbz90yi7rYqLvRWcFirpOs5ASSTxKLlH
         AaarooJtsNuLcdSnodRpgb+MThLnBq86kl2f0=
MIME-Version: 1.0
In-Reply-To: <359ed6810910130335m45919d6ala921d4cbfa5a341a@mail.gmail.com>
References: <20091007061701.GA7567@july>
	 <359ed6810910130335m45919d6ala921d4cbfa5a341a@mail.gmail.com>
Date: Tue, 13 Oct 2009 16:43:43 +0530
Message-ID: <5d5443650910130413t6ecd3d54p214d8f80972ed128@mail.gmail.com>
Subject: Re: [PATCH 1/6] Haptic: add haptic class
From: Trilok Soni <soni.trilok@gmail.com>
To: Jani Nikula <ext-jani.1.nikula@nokia.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kyungmin, Dmitry,

On Tue, Oct 13, 2009 at 4:05 PM, Jani Nikula
<ext-jani.1.nikula@nokia.com> wrote:
> On Wed, Oct 7, 2009 at 09:17, Kyungmin Park <kyungmin.park@samsung.com> wrote:
>> New haptic class support.
>> This class handles the haptic devices.
>
> I'm wondering why a haptic class is needed when there is force
> feedback support. Admittedly, I don't know the force feedback
> implementation too well, but could someone please enlighten me on
> this? Am I missing something here?
>
> I see haptics as simple force feedback, just with (usually) small
> force and short duration. There are devices out there doing haptics
> using vibra motors, which I think would be limited if implemented
> using this haptics class driver. Would it be somehow problematic
> interfacing with the simple haptic hardware using the force feedback
> API?

Please share your inputs on ff_device usage instead of haptics class.
I think Dmitry could add some points here as I don't see much users of
ff_device and I don't see any embedded device (like mobile) using it.

-- 
---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni
