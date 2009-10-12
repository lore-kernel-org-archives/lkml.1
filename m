Return-Path: <linux-kernel-owner+w=401wt.eu-S1758607AbZJLXJF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758607AbZJLXJF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 19:09:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757512AbZJLXJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 19:09:05 -0400
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:45566 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758244AbZJLXJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 19:09:04 -0400
Message-ID: <4AD3B6E2.9020703@euromail.se>
Date: Tue, 13 Oct 2009 01:08:18 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: bcm5974: report ABS_MT events
References: <1255386223-4109-1-git-send-email-rydberg@euromail.se>	<1255386223-4109-2-git-send-email-rydberg@euromail.se> <20091012154528.6830da60.akpm@linux-foundation.org>
In-Reply-To: <20091012154528.6830da60.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1MxU03-0005Xi-AA.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1MxU03-0005Xi-AA dcd54e4e60b4f1278acaa1da5cd7ab0d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Tue, 13 Oct 2009 00:23:43 +0200
> "Henrik Rydberg" <rydberg@euromail.se> wrote:
> 
>> This patch makes bcm5974 report raw multi-touch (MT) data in the form
>> of ABS_MT events. The module parameter (nomt) may be used to turn off
>> the effect of this patch.
>>
> 
> Why do we need a module parameter to disable the newly-added feature?

All MT events bypass the input filtering and gets sent directly to the X driver.
Although it works as intended, without visible side effects, the stream of
events is rather large, and since the bypassing is completely new behavior, I
felt compelled to provide an option to turn it all off. Perhaps it is just me
being paranoid.

> 
> IMO, your first patch ("input: bcm5974: retract efi-broken
> suspend_resume") is 2.6.32 material whereas this one is 2.6.33
> material?
> 
> This assumes that the two patches can be safely separated in this
> manner, which does appear to be the case.
> 

I was imagining both for 2.6.33; the efi booting is just beginning to work, and
since no distro is using it fully so far the problem currently only hits the
adventure-seekers anyways.

Cheers,
Henrik

