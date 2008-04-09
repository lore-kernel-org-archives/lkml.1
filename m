Return-Path: <linux-kernel-owner+w=401wt.eu-S1758644AbYDIUbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758644AbYDIUbk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 16:31:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753687AbYDIUbU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 16:31:20 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:37220 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753271AbYDIUbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 16:31:20 -0400
Date: Wed, 9 Apr 2008 15:31:19 -0500 (CDT)
From: Alan Mayer <ajm@sgi.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Alan Mayer <ajm@sgi.com>, torvalds@linux-foundation.org,
       linux-kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: Change FIRST_SYSTEM_VECTOR to a variable.
In-Reply-To: <86802c440804091328s4127422dk593384c32ba56e88@mail.gmail.com>
Message-ID: <Pine.SGI.3.96.1080409153018.8706317I-100000@fergus.americas.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> for x86_64, current from 0x20 to 0x2f, we only use one for irq migration.
> 
> wonder if you can use 2 from them for UV...
> 
> YH
> 

When all is said and done, we're going to need at least six more. Some
of them have to be high priority interrupts.  So I don't think that
would help.

		--ajm

Don't forget what you are.
You're a rock and roll star.
--
Alan J. Mayer
SGI
ajm@sgi.com
WORK: 651-683-3131
HOME: 651-407-0134
--

