Return-Path: <linux-kernel-owner+w=401wt.eu-S1763319AbYDOBpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763319AbYDOBpt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 21:45:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758130AbYDOBpl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 21:45:41 -0400
Received: from ZSM1387.piap.pl ([195.187.100.11]:55744 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756452AbYDOBpl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 21:45:41 -0400
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Marc Perkel <mperkel@yahoo.com>, Chris Snook <csnook@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: AMD Quad Core clock problem?
References: <47FFD3F3.50107@redhat.com>
	<821384.64293.qm@web52504.mail.re2.yahoo.com>
	<20080411213843.GH2160@csclub.uwaterloo.ca>
	<4802608A.3040901@zytor.com>
	<20080414151222.GF7385@csclub.uwaterloo.ca>
	<m3prsrj51j.fsf@maximus.localdomain> <480403DE.4070901@zytor.com>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Tue, 15 Apr 2008 03:45:38 +0200
In-Reply-To: <480403DE.4070901@zytor.com> (H. Peter Anvin's message of "Mon\, 14 Apr 2008 18\:24\:46 -0700")
Message-ID: <m3lk3fj3gd.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> It shouldn't really matter, since "below" produces a similar spectrum
> at a slightly lower frequency.

Sure for CPU/TSC and similar clocks but in case of well-known (not
calibrated) frequency it could be a problem. Not sure if there are
such cases.

I wonder if spread spectrum could affect calibration of (various)
timers - unlike NTP calibration is a short process.
-- 
Krzysztof Halasa
