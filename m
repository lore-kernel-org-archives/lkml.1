Return-Path: <linux-kernel-owner+w=401wt.eu-S1759325AbYJIM7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759325AbYJIM7f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 08:59:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758030AbYJIM71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 08:59:27 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53756 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757694AbYJIM70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 08:59:26 -0400
To: David John <davidjon@xenontk.org>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, clemens@ladisch.de,
       venkatesh.pallipadi@intel.com, vojtech@suse.cz, bob.picco@hp.com
Subject: Re: [PATCH] HPET: Remove the BKL.
From: Andi Kleen <andi@firstfloor.org>
References: <1223551371-3764-1-git-send-email-davidjon@xenontk.org>
Date: Thu, 09 Oct 2008 14:59:21 +0200
In-Reply-To: <1223551371-3764-1-git-send-email-davidjon@xenontk.org> (David John's message of "Thu,  9 Oct 2008 16:52:51 +0530")
Message-ID: <871vypudp2.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David John <davidjon@xenontk.org> writes:
> @@ -586,7 +583,7 @@ static const struct file_operations hpet_fops = {
>  	.llseek = no_llseek,
>  	.read = hpet_read,
>  	.poll = hpet_poll,
> -	.ioctl = hpet_ioctl,
> +	.unlocked_ioctl = hpet_ioctl,

Did this actually compile without warning? unlocked_ioctl 
has a different prototype than ioctl

-Andi

-- 
ak@linux.intel.com
