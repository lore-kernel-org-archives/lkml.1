Return-Path: <linux-kernel-owner+w=401wt.eu-S1756622AbYGRLhI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622AbYGRLhI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 07:37:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755271AbYGRLgz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 07:36:55 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:12546 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183AbYGRLgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 07:36:54 -0400
To: Takashi Iwai <tiwai@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
       robert.moore@intel.com
Subject: Re: Endless ACPI errors on Linus tree (5b664cb235)
From: Andi Kleen <andi@firstfloor.org>
References: <s5hzlof1ll2.wl%tiwai@suse.de>
Date: Fri, 18 Jul 2008 13:35:48 +0200
In-Reply-To: <s5hzlof1ll2.wl%tiwai@suse.de> (Takashi Iwai's message of "Fri, 18 Jul 2008 13:24:41 +0200")
Message-ID: <87od4vqvaj.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 18 Jul 2008 11:35:46.0595 (UTC) FILETIME=[6B93DF30:01C8E8CA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai <tiwai@suse.de> writes:

> the boot with the latest Linus git tree fails on x86-64 due to the
> endless kernel messages like below:
>
>     ACPI Error (evpge-0710): No handler or method for GPE[10],
>     disabling event[20080609]
>
> It happens on today's tree and also on yesterday (33af79d12e).
> The config is below.

That was after the ACPI merge I assume?  Do you have a full boot log?

Revert candidates to test would be e38e8a0743b0e996a8a3fbea8908fe75a84f02c7
and c91d924e3af08d4f98eab6ebf81f2b8ce132448f (Bob, that were both
changes from you for evgpe.c). Can you see if reverting
those helps? If yes which?

Thanks.

-Andi
