Return-Path: <linux-kernel-owner+w=401wt.eu-S1754557AbYIJQ4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557AbYIJQ4i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 12:56:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752370AbYIJQ43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 12:56:29 -0400
Received: from hpsmtp-eml13.kpnxchange.com ([213.75.38.113]:28845 "EHLO
	hpsmtp-eml13.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752321AbYIJQ43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 12:56:29 -0400
From: Frans Pop <elendil@planet.nl>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Time travel experiment?
Date: Wed, 10 Sep 2008 18:56:24 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <200809101658.06935.elendil@planet.nl> <200809101755.19927.elendil@planet.nl> <200809101825.29276.elendil@planet.nl>
In-Reply-To: <200809101825.29276.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809101856.24997.elendil@planet.nl>
X-OriginalArrivalTime: 10 Sep 2008 16:56:25.0296 (UTC) FILETIME=[290B2D00:01C91366]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 September 2008, Frans Pop wrote:
> On Wednesday 10 September 2008, Frans Pop wrote:
> > > > $ date
> > > > Wed Jul  3 23:09:23 CEST 2024

Aaah, hmmm.

I'm trying to trace a problem with resume. Once in every 5-10 times resume 
fails with dead display even though most times it resumes perfectly. So I 
was trying the suggestion in Documentation/power/s2ram.txt and am doing
'echo 1 > /sys/power/pm_trace' before suspending.

Just now I find [1] which mentions that the trace info is saved in the 
RTC, which I guess could well explain the jump. If that's what behind 
this, wouldn't it make sense to mention that fact in s2ram.txt?

But I would not expect the RTC to get changed when the resume is 
successful. Or does it just get updated with every resume step without a 
reset to the pre-trace value on completion?

[1]https://lists.linux-foundation.org/pipermail/linux-pm/2006-June/008470.html
