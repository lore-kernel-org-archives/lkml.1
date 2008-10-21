Return-Path: <linux-kernel-owner+w=401wt.eu-S1753111AbYJUAYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111AbYJUAYu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 20:24:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754893AbYJUAYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 20:24:40 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:63818 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754872AbYJUAYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 20:24:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=EOk+tADlpQlXliJgwkNIuccQbEQnIljjz7cnCBaf7+wLSXRfeBGYKyo39osevAQvPU
         9qljjNWRSC1FjgJAk60h27Jw4lI/1pzsILD96La4Pa2Z1cKVxep30DKaVX1wSpdRf49E
         2ZAL7L8HUl3nfvyfRjREP+HyP/Ap7n8lNuDaM=
Message-ID: <4b6fba110810201724v41d26dd8lc9abcba129599fd1@mail.gmail.com>
Date: Mon, 20 Oct 2008 20:24:38 -0400
From: "Daniel Rosenthal" <danielrosenthal@acm.org>
To: LKML <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>
Subject: behavior of hrtimers scheduled to expire in the past
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: 818f32c32b7200b6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What is the intended behavior for an hrtimer that is scheduled to
expire in the past?  I assumed that it would simply be scheduled to
expire at the nearest available time in the future, but I wrote some
scheduler code and it looks like hrtimers don't go off at all if they
are not scheduled to go off at a time which is after rq->clock.  Is
this the intended behavior or is this a bug?

Daniel
