Return-Path: <linux-kernel-owner+w=401wt.eu-S2993089AbXDRUAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993089AbXDRUAz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 16:00:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993100AbXDRUAz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 16:00:55 -0400
Received: from nz-out-0506.google.com ([64.233.162.232]:33355 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993089AbXDRUAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 16:00:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PFWf7ygptoCj2m1+Vk+nhm4fC5Rlj4DQHkS8uPjaPeNt9gy1D2cvgjKPRoiX59kIwdiAWAr53WKeZvry118RgHwbgw4GK/IUCXj1AHKvfF9MTgSxpCwR5IrsYw3BNasEAhfGZfdaeBZjsYeLd/lOazuCTd0WWD8n17CCmYchtNI=
Message-ID: <38b3b7c0704181300p78df84f3h8fd4e74428d4e4d8@mail.gmail.com>
Date: Wed, 18 Apr 2007 22:00:53 +0200
From: "johann deneux" <johann.deneux@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: [RFC 1/2] Input: ff, add FF_RAW effect
Cc: linux-kernel@vger.kernel.org, "Dmitry Torokhov" <dtor@insightbb.com>,
       stenyak@gmail.com, linux-input@atrey.karlin.mff.cuni.cz
In-Reply-To: <210731960111436322@karneval.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <210731960111436322@karneval.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri,

Which solution did you chose to implement? From what I remember, we
last discussed Dmitry's idea of specifying an axis for an effect, then
combine several effects to achieve complex effects.
The implementation would specify the axis using the upper bits of the
effect type.

The patches you have sent seem to implement an easier, but in my
opinion inferior solution. If this FF_RAW effect does not have
semantics which are meaningful for other kinds of devices, I think
using the FF API is not a good idea.


On 4/17/07, Jiri Slaby <jirislaby@gmail.com> wrote:
> So fellows, what about these ones?
>
> --
>
> ff, add FF_RAW effect
>
> Add new FF_RAW effect for devices such Phantom. The new model has up to 6DOF
> torque force feedback independent on any 3d-or-so value.
>
