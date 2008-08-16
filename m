Return-Path: <linux-kernel-owner+w=401wt.eu-S1754621AbYHPXdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621AbYHPXdY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 19:33:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751896AbYHPXdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 19:33:16 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:45903 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742AbYHPXdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 19:33:15 -0400
Date: Sun, 17 Aug 2008 00:33:18 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alex Villacis Lasso <avillaci@ceibo.fiec.espol.edu.ec>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Bug #11260] Regression: USB memory stick triggers several USB
 resets before settling with bogus capacity
In-Reply-To: <sNRO-BDDjQL.A.pSG.rbzpIB@albercik>
Message-ID: <Pine.LNX.4.64.0808170028550.25704@blonde.site>
References: <DLWXHEp37wB.A.duD.yZzpIB@albercik> <sNRO-BDDjQL.A.pSG.rbzpIB@albercik>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Aug 2008, Rafael J. Wysocki wrote:
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11260
> Subject		: Regression: USB memory stick triggers several USB resets before settling with bogus capacity
> Submitter	: Alex Villacis Lasso <avillaci@ceibo.fiec.espol.edu.ec>
> Date		: 2008-08-06 13:33 (11 days old)
> Handled-By	: Hugh Dickins <hugh@veritas.com>
> Patch		: http://marc.info/?l=linux-kernel&m=121804333614405&w=2

James has this fix queued in his scsi-rc-fixes for 2.6.27

http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-rc-fixes-2.6.git;a=commit;h=d211f052fa58a053639bc51501cb64421157d362

but hasn't asked Linus to pull for a while: I'm hoping it'll get into -rc4.

Hugh
