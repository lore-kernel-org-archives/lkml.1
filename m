Return-Path: <linux-kernel-owner+w=401wt.eu-S1752760AbYLSU3M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760AbYLSU3M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 15:29:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751164AbYLSU24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 15:28:56 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:53560 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750978AbYLSU2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 15:28:55 -0500
Subject: Re: Firmware patches for SCSI
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Jaswinder Singh <jaswinderlinux@gmail.com>
Cc: linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <3f9a31f40812191153n636888f4i549409453266d58c@mail.gmail.com>
References: <3f9a31f40812191153n636888f4i549409453266d58c@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 19 Dec 2008 15:29:03 -0500
Message-Id: <1229718543.18778.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-12-20 at 01:23 +0530, Jaswinder Singh wrote:
> Hello all,
> 
> These SCSI's firmware patches are floating in linux-next from long time :
> 
> 1. qla1280: use request_firmware
> http://git.kernel.org/?p=linux/kernel/git/sfr/linux-next.git;a=commit;h=7c84df1aec1bbb4e43ac9e2ba65b137042279a8d
> 2. advansys: use request_firmware
> http://git.kernel.org/?p=linux/kernel/git/sfr/linux-next.git;a=commit;h=baca2b168d3b7340eac87414c046f7d49de4bf71
> 3. qlogicpti: use request_firmware
> http://git.kernel.org/?p=linux/kernel/git/sfr/linux-next.git;a=commit;h=2c68b5b6db13786a425accc8576217b120f885f2
> 
> Should I need to resend these patches to merge main-stream.

Um ... depends how they got into linux-next.  The head commit just says

Merge commit 'firmware/master'

Which isn't very descriptive of where it came from.  It looks like
either a tree that linux-next shouldn't pull (or one the owner forgot to
push to linus).

James


