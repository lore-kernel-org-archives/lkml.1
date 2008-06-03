Return-Path: <linux-kernel-owner+w=401wt.eu-S1756534AbYFCTwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756534AbYFCTwy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 15:52:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754396AbYFCTwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 15:52:44 -0400
Received: from 41-052.adsl.zetnet.co.uk ([194.247.41.52]:45472 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754164AbYFCTwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 15:52:43 -0400
To: Daniel Hazelton <dhazelton@enter.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jeff Dike <jdike@addtoit.com>,
       akpm@linuxfoundation.org, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [PATCH 1/6] UML - Deal with host time going backwards
References: <20080603190235.GA9511@c2.user-mode-linux.org>
	<20080603123211.e129c222.akpm@linux-foundation.org>
	<200806031543.56864.dhazelton@enter.net>
From: Nix <nix@esperi.org.uk>
Emacs: an inspiring example of form following function... to Hell.
Date: Tue, 03 Jun 2008 20:52:18 +0100
In-Reply-To: <200806031543.56864.dhazelton@enter.net> (Daniel Hazelton's message of "Tue, 3 Jun 2008 15:43:56 -0400")
Message-ID: <878wxmfg99.fsf@hades.wkstn.nix>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b28 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC--Metrics: hades 1114; Body=6 Fuz1=6 Fuz2=6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 Jun 2008, Daniel Hazelton said:

> On Tuesday 03 June 2008 03:32:11 pm Andrew Morton wrote:
>> On Tue, 3 Jun 2008 15:02:35 -0400
>>
>> Jeff Dike <jdike@addtoit.com> wrote:
>> > Protection against the host's time going backwards - keep track of the
>> > time at the last tick and if it's greater than the current time, keep
>> > time stopped until the host catches up.
>>
>> Strange.  What would cause the host's time (or at least UML's perception
>> of it) to go backwards?
>
> A wild guess would be that the UML process is running "fast" at some point and 
> its expectation of the host's time is skewed forward because of that.

Quite so. Simply running ntp on the host (in slew-only mode, no less!) 
can cause this.

> Another possibility is that the hosts clock got reset between the times UML 
> has checked it and the correction was a negative one.

That too.

-- 
`If you are having a "ua luea luea le ua le" kind of day, I can only
 assume that you are doing no work due [to] incapacitating nausea caused 
 by numerous lazy demons.' --- Frossie
