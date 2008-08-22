Return-Path: <linux-kernel-owner+w=401wt.eu-S1754329AbYHVOdj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329AbYHVOdj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 10:33:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752795AbYHVOdc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 10:33:32 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:14441 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146AbYHVOdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 10:33:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=jOlrTKV5CaYDdZn4R7rdYQkS5DAqRELnlQdK9hj+56Pn7/T+mV16Oc1A6aXgMqXvdp
         Y0M1DBuTBIPuo2iAHi6ahWeyqJlbB0p3AUqIJuc+zfqbdpwCnpegzf6IGGExehfmv4ik
         rr3DM5Pf0moHgUGW+hVigagQ/d2COzlKKGlJU=
Message-ID: <9e4733910808220733o7a8904do9dec947dde7d09c0@mail.gmail.com>
Date: Fri, 22 Aug 2008 10:33:30 -0400
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Eric Miao" <eric.y.miao@gmail.com>
Subject: Re: Fundamental Design Flaw of the Device Driver Model?
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <f17812d70808212325m24f25518t5e8dd2fc5e7919b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f17812d70808212325m24f25518t5e8dd2fc5e7919b@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/22/08, Eric Miao <eric.y.miao@gmail.com> wrote:
======================================================
>    This, however, creates many questions you have to face with:
>
>    1. on what bus shall these sub-devices be?
>       ** this is the reason I choose to use "platform_device", at least they
>       can reside on the platform_bus_type, thus platform_driver can be used
>       for this sub-device

Another option is making your own bus. If I understand your hardware
it effectively has an internal bus.

-- 
Jon Smirl
jonsmirl@gmail.com
