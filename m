Return-Path: <linux-kernel-owner+w=401wt.eu-S1754479AbZFXXFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479AbZFXXFv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 19:05:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751577AbZFXXFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 19:05:43 -0400
Received: from smtp-out.google.com ([216.239.45.13]:58458 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbZFXXFm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 19:05:42 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=f38MNckN3KCcAgCk1J3GHQSIG2ovxKyHU1pdgXgBv49BBT/nXLJf6Gz9lhvt/81Iy
	ENaOvyyHq+Vff9oksI5rg==
MIME-Version: 1.0
In-Reply-To: <1245883778.32124.214.camel@desktop>
References: <1244832678-30329-1-git-send-email-dwalker@fifo99.com>
	 <4A391A54.7000109@goop.org>
	 <d6200be20906171426n71979124i4b359b6f4fc35d7e@mail.gmail.com>
	 <1245274308.5982.268.camel@desktop>
	 <a55d774e0906191220i7280fe77qb724037fb92fab86@mail.gmail.com>
	 <1245451983.32124.25.camel@desktop>
	 <d6200be20906191713n161d4281u1f43804e675e29ac@mail.gmail.com>
	 <1245849223.32124.112.camel@desktop>
	 <a55d774e0906241514w761f86fva294784583cdd8a4@mail.gmail.com>
	 <1245883778.32124.214.camel@desktop>
Date: Wed, 24 Jun 2009 16:05:42 -0700
Message-ID: <a55d774e0906241605u1e7aa816n823aad517f05a1e1@mail.gmail.com>
Subject: Re: [PATCH 1/6] staging: android: binder: Remove some funny && usage
From: Brian Swetland <swetland@google.com>
To: Daniel Walker <dwalker@fifo99.com>
Cc: =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Greg Kroah-Hartman <greg@kroah.com>, linux-kernel@vger.kernel.org,
       hackbod@android.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 24, 2009 at 3:49 PM, Daniel Walker<dwalker@fifo99.com> wrote:
>> For example the msm7k SoC code may need some various cleanup, but I
>> think at the end of the day adding support for a new ARM based SoC and
>> peripherals is not going to be that contentious.  The
>> wakelock/suspendblock stuff is a bit further out there, but there
>> seemed to be some good progress on getting it reviewed and revised on
>> the linux-pm list, last I saw.
>
> Do you have a msm branch someplace that is strictly msm support with
> absolutely no generic changes mixed in?

Unfortunately, no.  However, the generic changes tend to be
self-contained (binder, logger, etc) and not necessary for core msm7k
support.  The one set of changes that does touch both generic and
platform code is the wakelock/suspendblock stuff, which some of the
drivers make use of, but that's usually not very invasive.

http://android.git.kernel.org/?p=kernel/msm.git;a=shortlog;h=refs/heads/android-msm-2.6.29
is the most up to date msm7k tree.

We'll be rebasing on a newer kernel baseline in the near future (.29
is obviously not the cutting edge, but is what's being supported for
the upcoming donut release of the android platform).

Brian
