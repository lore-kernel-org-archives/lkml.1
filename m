Return-Path: <linux-kernel-owner+w=401wt.eu-S933575AbXBXW5h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933575AbXBXW5h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 17:57:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933580AbXBXW5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 17:57:37 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:14335 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933575AbXBXW5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 17:57:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mpc8S6V50F5RVC1i9/mRFZSkkKzwTEnaFXvs6pu2AWwypq3a1R0wGXxJDJ8KFj23uQQXMP212f5QY+cGaI74TYCEp3fSIG9q3N+qAzEvLHBF41sfL55msW4w9CbJfrOHoSEen0ebNT0xamnlR/GCVUy434SmSE4FVIdd6CWyeiU=
Message-ID: <21d7e9970702241457n746aa069y8dd4e97a07996eed@mail.gmail.com>
Date: Sun, 25 Feb 2007 09:57:34 +1100
From: "Dave Airlie" <airlied@gmail.com>
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
Subject: Re: Video GL rendering worked only between 2.6.20 and 2.6.21-rc1
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070223180643.GA6828@Ahmed>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070223180643.GA6828@Ahmed>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The machine is a Centrino laptop with an i810 card. So I guess those are
> the responsible files:
>
>     drivers/char/drm/i810_*.c
>     drivers/video/i810/*

drivers/char/agp/i810*
and
drivers/char/drm/i915*

are most likely.. but it could be anything in the DRM or AGP subdirs..
 perhaps two X.org logs showing the difference..

Dave.
