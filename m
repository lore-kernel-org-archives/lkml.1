Return-Path: <linux-kernel-owner+w=401wt.eu-S1754014AbYIJRDl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014AbYIJRDl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 13:03:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752326AbYIJRDb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 13:03:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46881 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752313AbYIJRDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 13:03:31 -0400
Date: Wed, 10 Sep 2008 10:02:41 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Frans Pop <elendil@planet.nl>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Time travel experiment?
In-Reply-To: <200809101856.24997.elendil@planet.nl>
Message-ID: <alpine.LFD.1.10.0809101001360.3384@nehalem.linux-foundation.org>
References: <200809101658.06935.elendil@planet.nl> <200809101755.19927.elendil@planet.nl> <200809101825.29276.elendil@planet.nl> <200809101856.24997.elendil@planet.nl>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 10 Sep 2008, Frans Pop wrote:
> 
> But I would not expect the RTC to get changed when the resume is 
> successful. Or does it just get updated with every resume step without a 
> reset to the pre-trace value on completion?

Indeed. We don't know where the bug happens when tracing, so each 
trace-point just writes its hash value into it. And nothing restores it, 
since nothing knows that the resume is "done" (a lot of problems happen 
due to X interactions much later than the 'core' resume thing).

		Linus
