Return-Path: <linux-kernel-owner+w=401wt.eu-S1751847AbYANOWw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751847AbYANOWw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 09:22:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750744AbYANOWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 09:22:44 -0500
Received: from def92-3-81-56-114-101.fbx.proxad.net ([81.56.114.101]:47659
	"EHLO barad-dur.regala.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbYANOWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 09:22:43 -0500
To: Matthew Wilcox <matthew@wil.cx>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Convert drivers/scsi/ch.c to use unlocked_ioctl
References: <1200317533-24643-1-git-send-email-mathieu.segaud@regala.cx>
	<20080114141854.GJ18741@parisc-linux.org>
From: Mathieu SEGAUD <mathieu.segaud@regala.cx>
Date: Mon, 14 Jan 2008 15:22:42 +0100
In-Reply-To: <20080114141854.GJ18741@parisc-linux.org> (Matthew Wilcox's message of "Mon\, 14 Jan 2008 07\:18\:54 -0700")
Message-ID: <87odbotrkd.fsf@barad-dur.regala.cx>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vous m'avez dit récemment :

> On Mon, Jan 14, 2008 at 02:32:13PM +0100, Mathieu Segaud wrote:
>> +#include <linux/smp_lock.h>
> You don't add any uses of lock_kernel() and there are none in the
> driver currently.

yep, it was before I noticed the locking semantics of
ch_ioctl_compat()

>> -	.owner        = THIS_MODULE,
>> -	.open         = ch_open,
>> -	.release      = ch_release,
>> -	.ioctl        = ch_ioctl,
>> +	.owner          = THIS_MODULE,
>> +	.open           = ch_open,
>> +	.release        = ch_release,
>> +	.unlocked_ioctl = ch_ioctl,
>
> If you're going to do the gratuitous reformatting, at least use tabs
> instead of spaces.

thanks, will do

> Other than that, should be fine.

I repost this one
thanks a lot.

-- 
Mathieu

