Return-Path: <linux-kernel-owner+w=401wt.eu-S1759096AbZFMUtP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759096AbZFMUtP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 16:49:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753017AbZFMUs7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 16:48:59 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:60275 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752523AbZFMUs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 16:48:58 -0400
Subject: Re: [GIT PULL] a couple of SCSI bug fixes from the last update
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1244915748.5323.30.camel@mulgrave.site>
References: <1244915748.5323.30.camel@mulgrave.site>
Content-Type: text/plain
Date: Sat, 13 Jun 2009 15:48:56 -0500
Message-Id: <1244926136.5323.60.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-06-13 at 12:55 -0500, James Bottomley wrote:
> This just fixes up a couple of config based problems in the cnic driver
> (which is the broadcom iSCSI base).
> 
> The patch is available here:
> 
> master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git

I was going to ask you to cancel this pull request since it has the bad
patch from Ingo in it.  However, when we get the cnic properly sorted
out, I'll include a revert for it ... the double include is harmless
until then.

James


