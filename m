Return-Path: <linux-kernel-owner+w=401wt.eu-S1752810AbYKGO0y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810AbYKGO0y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 09:26:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751390AbYKGO0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 09:26:45 -0500
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:37984 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750904AbYKGO0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 09:26:45 -0500
Message-ID: <49145016.7090206@euromail.se>
Date: Fri, 07 Nov 2008 15:26:30 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: "J.R. Mauro" <jrm8005@gmail.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: Add a detailed multi-touch finger data report
 protocol
References: <49142351.9080805@euromail.se> <3aaafc130811070534p54eebeb6q9b57d3e847ed859a@mail.gmail.com>
In-Reply-To: <3aaafc130811070534p54eebeb6q9b57d3e847ed859a@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.192.132
X-Scan-Result: No virus found in message 1KySIL-0000EO-95.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1KySIL-0000EO-95 b37f61cbce13f6b5299e01b56e7d3615
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

J.R. Mauro wrote:
> On Fri, Nov 7, 2008 at 6:15 AM, Henrik Rydberg <rydberg@euromail.se> wrote:
>> In order to utilize the full power of the new multi-touch devices, a
>> way to report detailed finger data to user space is needed. This patch
>> adds a multi-touch (MT) protocol which allows drivers to report details
>> for an arbitrary number of fingers.
> 
> This is a great idea, Henrik. How will things like X11 go about
> leveraging this functionality?

What I have in mind is this:

1. Add support for the MT interface in the trackpad drivers, to the extent
they support the information. First out is bcm5974, for which the interface
is designed. A patch is prepared, but I will keep it on hold for a little
while longer.

2. Add support for the MT protocol in Xorg synaptics and/or a new Xorg
multitouch driver. As you might have guessed, I have an experimental
driver, utilizing the MT protocol. It uses proper matching techniques
to obtain smooth multi-finger actions. My plan is to launch this in user
space as soon as there is kernel support.

Henrik

