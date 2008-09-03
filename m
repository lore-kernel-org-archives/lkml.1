Return-Path: <linux-kernel-owner+w=401wt.eu-S1755651AbYICMP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755651AbYICMP6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 08:15:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751611AbYICMPt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 08:15:49 -0400
Received: from khc.piap.pl ([195.187.100.11]:54308 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755288AbYICMPr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 08:15:47 -0400
To: Roland Dreier <rdreier@cisco.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, LKML <linux-kernel@vger.kernel.org>,
       "v4l-dvb maintainer list" <v4l-dvb-maintainer@linuxtv.org>
Subject: Re: CodingStyle question: multiple statements on a single line
References: <200809030021.00122.hverkuil@xs4all.nl>
	<ada7i9ufa7x.fsf@cisco.com>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Wed, 03 Sep 2008 14:15:44 +0200
In-Reply-To: <ada7i9ufa7x.fsf@cisco.com> (Roland Dreier's message of "Tue\, 02 Sep 2008 15\:34\:42 -0700")
Message-ID: <m3tzcxl91r.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier <rdreier@cisco.com> writes:

> This is correct.  Always write simple if statements as
>
> 	if (a)
> 		b;

The CodingStyle should never say "never" (nor "always").

Consider:

	if (a)		b;
	else if (c)	d;
	else if (e)	f;
	etc.

If the list is long and expressions simple this is IMHO much more
readable. The same with

	switch (a) {
	case b: c; break;
	case d: e; break;
	and so on.

> Keep in mind that common sense always trumps any mechanical rule.

Precisely.
-- 
Krzysztof Halasa
