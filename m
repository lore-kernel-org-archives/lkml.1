Return-Path: <linux-kernel-owner+w=401wt.eu-S1758851AbYJIKbu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758851AbYJIKbu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 06:31:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755533AbYJIKbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 06:31:42 -0400
Received: from one.firstfloor.org ([213.235.205.2]:50710 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755340AbYJIKbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 06:31:42 -0400
To: David John <davidjon@xenontk.org>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, clemens@ladisch.de,
       venkatesh.pallipadi@intel.com, vojtech@suse.cz, bob.picco@hp.com
Subject: Re: [PATCH] HPET: Remove the BKL.
From: Andi Kleen <andi@firstfloor.org>
References: <1223542535-3272-1-git-send-email-davidjon@xenontk.org>
Date: Thu, 09 Oct 2008 12:31:37 +0200
In-Reply-To: <1223542535-3272-1-git-send-email-davidjon@xenontk.org> (David John's message of "Thu,  9 Oct 2008 14:25:35 +0530")
Message-ID: <8763o2t5yu.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David John <davidjon@xenontk.org> writes:

> Concurrent access is protected by the spin lock hpet_lock. The
> BKL is not required.

You should probably also convert the .ioctl = ... to .unlocked_ioctl.
Otherwise you still got implicit BKL for the ioctls.

-Andi

-- 
ak@linux.intel.com
