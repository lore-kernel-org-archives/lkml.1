Return-Path: <linux-kernel-owner+w=401wt.eu-S1765352AbXGSMJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765352AbXGSMJS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 08:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757716AbXGSMJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 08:09:07 -0400
Received: from mail.suse.de ([195.135.220.2]:46673 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753106AbXGSMJG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 08:09:06 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Satyam Sharma" <satyam.sharma@gmail.com>
Subject: Re: [PATCH] [14/58] x86_64: Add on_cpu_single
Date: Thu, 19 Jul 2007 14:07:27 +0200
User-Agent: KMail/1.9.6
Cc: patches@x86-64.org, linux-kernel@vger.kernel.org
References: <200707191154.642492000@suse.de> <20070719095458.DB13914E06@wotan.suse.de> <a781481a0707190409r73fc0220g835fe818eeb2f6ac@mail.gmail.com>
In-Reply-To: <a781481a0707190409r73fc0220g835fe818eeb2f6ac@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707191407.27915.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> But probably you should just drop this ... with smp_call_function_single's
> new semantics, I don't see this function growing any users.

The new sched-clock uses it, but i'll update it to use smp_call_function_single

Thanks

-Andi
