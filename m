Return-Path: <linux-kernel-owner+w=401wt.eu-S1753199AbYIJQGK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199AbYIJQGK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 12:06:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751908AbYIJQF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 12:05:56 -0400
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:51115 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751838AbYIJQFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 12:05:55 -0400
Message-ID: <48C7F05F.8070308@euromail.se>
Date: Wed, 10 Sep 2008 18:05:51 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: akpm@osdl.org, linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] input: mousedev: Emulate right and middle buttons
 for single-button touchpads
References: <48C0893C.6060901@euromail.se> <20080910125228.GA25221@anvil.corenet.prv> <48C7DF08.4060208@euromail.se> <20080910153213.GA6940@USFSHXP-002051>
In-Reply-To: <20080910153213.GA6940@USFSHXP-002051>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.33.63
X-Scan-Result: No virus found in message 1KdSCX-0000Y7-7j.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1KdSCX-0000Y7-7j f66d5874881690fd40286ad800cef7a1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Regarding the tapping patch; it is addressing the correctness of
>> already implemented functionality. I can see nothing wrong with that.
>>
> 
> My position that since the isssue can be "fixed" by simply installing
> the proper X driver I'd rather not include it. Mousedev purpose is to
> provide good enough emulation in absence of a native driver and that's
> it. Also, the default value would not work well on high-resiolution
> devices (like Synaptics) and would require user fiddling with kernel
> parameters - not worth it in my opinion.

The parameter could be made dimensionless and the distance test scaled
with the size of the device; the argument invalidates the current patch,
but not the idea itself. Maybe the patch will appear in acceptable form
at some point, but for now, I rest my case.

Henrik
