Return-Path: <linux-kernel-owner+w=401wt.eu-S1757070AbZC2UQ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757070AbZC2UQ7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 16:16:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753704AbZC2UQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 16:16:49 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:47545 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029AbZC2UQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 16:16:48 -0400
Message-ID: <49CFD72A.5010107@davidnewall.com>
Date: Mon, 30 Mar 2009 06:46:42 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linux-ext4@vger.kernel.org
Subject: Re: Zero length files - an alternative approach?
References: <87bprka9sg.fsf@newton.gmurray.org.uk> <yw1xab744lqi.fsf@thrashbarg.mansr.com> <49CF636A.3030400@ursus.ath.cx> <yw1x1vsg4jio.fsf@thrashbarg.mansr.com> <20090329134901.GB13737@elf.ucw.cz>
In-Reply-To: <20090329134901.GB13737@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> fsync() is easy. But some people _want_ to have either newdata _or_
> olddata, but don't care which one, and would prefer to avoid
> fsync. That's where replace() should help...

Most people, I wager, care more about their code being portable than
they do about leaping through a Linux-specific hoop.  They're not going
to use replace; not ever; that's what link/unlink is for.

If you think it's reasonable to modify every instance in applications
where a sudden crash would cause data loss, why not make a mount-time
flag that does all of that in FS; and for the other 99% of users, it
doesn't, but runs faster?
