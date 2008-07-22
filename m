Return-Path: <linux-kernel-owner+w=401wt.eu-S1756346AbYGVA4L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756346AbYGVA4L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 20:56:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753424AbYGVAz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 20:55:57 -0400
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:39840 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752268AbYGVAz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 20:55:57 -0400
Subject: Re: [PATCH] linux-input: bcm5974-0.57: mode-switch to atp_open,
	cleanup bug fixed
From: Henrik Rydberg <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       robfitz@273k.net, akpm@osdl.org, jikos@jikos.cz, vojtech@suse.cz,
       dmonakhov@openvz.org, johannes@sipsolutions.net
In-Reply-To: <20080720051016.GA7853@anvil.corenet.prv>
References: <1216466049.6238.0.camel@alnilam>
	 <20080720051016.GA7853@anvil.corenet.prv>
Content-Type: text/plain
Date: Tue, 22 Jul 2008 02:55:42 +0200
Message-Id: <1216688142.4768.26.camel@alnilam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.35.11
X-Scan-Result: No virus found in message 1KL6AV-0005wY-4o.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1KL6AV-0005wY-4o 540e46bf40b8a6525103683995ad4f97
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitri,

Regarding open/close and suspend/resume, I have difficulties finding out
what the proper behavior is for the various error states that can
appear. I also wonder whether open should commute with suspend or not.
It would be of great help to get answers to the scenarios below.

1. From the state (!opened,!suspended), calling open followed by
suspend, or suspend followed by open, are we in the same state?

2. From the state (!opened,!suspended), calling open fails. What state
are we in?

3. From the state (!opened,suspended), calling open gets us to what
state?

4. From the state (!opened,suspended), calling open fails. Where are we?

5. From the state (opened,suspended), calling resume fails. What state
are we in?

Best regards,
Henrik Rydberg


