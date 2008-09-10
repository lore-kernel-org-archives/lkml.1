Return-Path: <linux-kernel-owner+w=401wt.eu-S1752988AbYIJOwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988AbYIJOwS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 10:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751814AbYIJOwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 10:52:06 -0400
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:49794 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751293AbYIJOwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 10:52:05 -0400
Message-ID: <48C7DF08.4060208@euromail.se>
Date: Wed, 10 Sep 2008 16:51:52 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: akpm@osdl.org, linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] input: mousedev: Emulate right and middle buttons
 for single-button touchpads
References: <48C0893C.6060901@euromail.se> <20080910125228.GA25221@anvil.corenet.prv>
In-Reply-To: <20080910125228.GA25221@anvil.corenet.prv>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.33.63
X-Scan-Result: No virus found in message 1KdR33-0000ft-8j.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1KdR33-0000ft-8j 1707ce7246e57b9baecc88edb3c401a5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings Dmitry,

> On Fri, Sep 05, 2008 at 03:19:56AM +0200, Henrik Rydberg wrote:
>> On most linux-based systems, the right and middle buttons are used
>> extensively. On computers lacking either of those buttons, such as
>> the Apple Macbooks, emulation is needed. This patch adds emulation
>> of the missing buttons via two-fingers-and-click and three-fingers-
>> and-click operations, which has recently become standard, both in
>> MacOS and in the Xorg synaptics driver.
>>
> 
> The standard way of emulating right and middle button presses for
> "button-deficient" devices is to use Macintosh emulation
> (MAC_EMUMOUSEBTN) that works not only for touchpads but for regular mice
> as well.

I have a hard time believing that in five years from now, people will
still consider pressing a key on the keyboard the standard way to
emulate a right click. Nevertheless, I can see the point in moving
away from user-land decisions in the kernel. I will not pursue this one
further, although it is a rather neat piece of functionality.

> Overall I don't think we should enhance mousedev for scenarios where
> proper solution is to install Synaptics X driver. This also goes for
> your other patch improving tapping in mousedev.

Regarding the tapping patch; it is addressing the correctness of
already implemented functionality. I can see nothing wrong with that.

Henrik
