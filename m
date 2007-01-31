Return-Path: <linux-kernel-owner+w=401wt.eu-S1030497AbXAaSPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030497AbXAaSPy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 13:15:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030500AbXAaSPy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 13:15:54 -0500
Received: from smtp4-g19.free.fr ([212.27.42.30]:54932 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030497AbXAaSPx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 13:15:53 -0500
From: Duncan Sands <duncan.sands@math.u-psud.fr>
To: Simon Arlott <b3c83437033a245c3e1hcjxk0000jq7l@thunder.lp0.eu>
Subject: Re: [PATCH 2/3] cxacru: Poll for device status more frequently.
Date: Wed, 31 Jan 2007 19:15:41 +0100
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <45BFB841.9030200@simon.arlott.org.uk> <200701311527.39343.duncan.sands@math.u-psud.fr> <45C0D602.70708@simon.arlott.org.uk>
In-Reply-To: <45C0D602.70708@simon.arlott.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701311915.42340.duncan.sands@math.u-psud.fr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I've had it polling every 200ms on a dual ppro200 since november,
> and it has never failed to poll the status. 

Great, that's certainly better than the speedtouch ;)
I can't help feeling that polling twice a second is overkill.
How about changing it to poll every 5 seconds if the line is
up, and ten times as fast (as in this patch) if the line is
down?  Also, what is the point of polling fast?  Does it matter
if you miss some down-try_to_activate transitions?

Best wishes,

Duncan.
