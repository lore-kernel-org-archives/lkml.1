Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753185AbYLQWpT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185AbYLQWpT (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 17:45:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751996AbYLQWpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 17:45:04 -0500
Received: from one.firstfloor.org ([213.235.205.2]:47812 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961AbYLQWpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 17:45:03 -0500
To: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: FPU emulation broken in 2.6.28-rc8 ?
From: Andi Kleen <andi@firstfloor.org>
References: <20081217085620.GA20184@bitwizard.nl>
	<20081217203227.GA10899@bitwizard.nl>
Date: Wed, 17 Dec 2008 23:45:39 +0100
In-Reply-To: <20081217203227.GA10899@bitwizard.nl> (Rogier Wolff's message of "Wed, 17 Dec 2008 21:32:27 +0100")
Message-ID: <878wqe1kvg.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rogier Wolff <R.E.Wolff@BitWizard.nl> writes:
>> 
>> I'm trying to set up a thin client, which runs on a geode, which
>> apparently doesn't have a FPU.... (/proc/cpuinfo mentions the flag 
>> "fpu", what does THAT mean?)

Geodes all have FPUs to my knowledge.
The only FPU less x87s are 386s and special 486s (and a few emulators)

If the FPU doesn't work on the Geode something else must be broken
(or your CPU is not really a Geode)

-Andi

-- 
ak@linux.intel.com
