Return-Path: <linux-kernel-owner+w=401wt.eu-S1753985AbYECWYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985AbYECWYT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 18:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750890AbYECWYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 18:24:06 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:32998 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750698AbYECWYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 18:24:04 -0400
Subject: Re: modprobe aha1542 oops with git17
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: devzero@web.de
Cc: akpm@linux-foundation.org, jgarzik@redhat.com, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <263898027@web.de>
References: <263898027@web.de>
Content-Type: text/plain
Date: Sat, 03 May 2008 17:23:59 -0500
Message-Id: <1209853439.3075.26.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-05-03 at 22:29 +0200, devzero@web.de wrote:
> this also happens on real hardware with latest git - no aha1542
> attached
> 
> didn`t happen before - looks like a regression to me

Actually, if you check with our tool sets:

http://www.kerneloops.org/search.php?search=scsi_destroy_command_freelist&btnG=Function+Search

They'll point you to the bugzilla entry:

http://bugzilla.kernel.org/show_bug.cgi?id=10598

And the fix (which is now upstream):

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=61d7416a286e840d905c18b1e6b0977c036c8656

James


