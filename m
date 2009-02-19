Return-Path: <linux-kernel-owner+w=401wt.eu-S1753961AbZBSD4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961AbZBSD4Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 22:56:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751382AbZBSD4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 22:56:15 -0500
Received: from mga02.intel.com ([134.134.136.20]:27630 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751078AbZBSD4O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 22:56:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,231,1233561600"; 
   d="scan'208";a="491257195"
Subject: Re: i915 regression in 2.6.29-rc5
From: Zhang Rui <rui.zhang@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <86802c440902181133x320c80f6ue0dbb38880ffe267@mail.gmail.com>
References: <1234927467.4707.15.camel@rzhang-desktop>
	 <86802c440902181133x320c80f6ue0dbb38880ffe267@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Date: Thu, 19 Feb 2009 11:55:43 +0800
Message-Id: <1235015743.32297.53.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-19 at 03:33 +0800, Yinghai Lu wrote:
> On Tue, Feb 17, 2009 at 7:24 PM, ZhangRui <rui.zhang@intel.com> wrote:
> > Hi, all,
> >
> > I got an i915 failure in 2.6.29-rc5.
> >
> > problem description: the screen doesn't come back after suspend/resume.
> > A workaround is to boot with "nomodesetting".
> >
> > I got this error message during i915 driver load time,
> > [   22.606749] mtrr: type mismatch for e0000000,10000000 old: write-back new: write-combining
> > [   22.606752] [drm] MTRR allocation failed
> > [   22.606753] .  Graphics performance may suffer.
> 
> CONFIG_MTRR_SANITIZER=y
> CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=1
> CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
> 
> may help this one.
> 
hah, it helps.
the screen is back with this, while my previous kernel option is same
except that ﻿CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0.

Btw: with jesse's patch applied, the symptom is exactly the same as the
one I stated in the previous email.

thanks,
rui

