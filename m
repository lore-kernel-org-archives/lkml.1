Return-Path: <linux-kernel-owner+w=401wt.eu-S1764631AbXEYSOO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764631AbXEYSOO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 14:14:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762603AbXEYSN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 14:13:58 -0400
Received: from sccrmhc12.comcast.net ([204.127.200.82]:38367 "EHLO
	sccrmhc12.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565AbXEYSN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 14:13:56 -0400
From: Jeremy Maitin-Shepard <jbms@cmu.edu>
To: casey@schaufler-ca.com
Cc: Andreas Gruenbacher <agruen@suse.de>, James Morris <jmorris@namei.org>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 01/41] Pass struct vfsmount to the inode_create LSM hook
References: <267570.85171.qm@web36604.mail.mud.yahoo.com>
	<87fy5kpye6.fsf@jbms.ath.cx>
X-Habeas-SWE-9: mark in spam to <http://www.habeas.com/report/>.
X-Habeas-SWE-8: Message (HCM) and not spam. Please report use of this
X-Habeas-SWE-7: warrant mark warrants that this is a Habeas Compliant
X-Habeas-SWE-6: email in exchange for a license for this Habeas
X-Habeas-SWE-5: Sender Warranted Email (SWE) (tm). The sender of this
X-Habeas-SWE-4: Copyright 2002 Habeas (tm)
X-Habeas-SWE-3: like Habeas SWE (tm)
X-Habeas-SWE-2: brightly anticipated
X-Habeas-SWE-1: winter into spring
Date: Fri, 25 May 2007 14:13:25 -0400
In-Reply-To: <87fy5kpye6.fsf@jbms.ath.cx> (Jeremy Maitin-Shepard's message of
	"Fri\, 25 May 2007 14\:10\:41 -0400")
Message-ID: <87bqg8py9m.fsf@jbms.ath.cx>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Maitin-Shepard <jbms@cmu.edu> writes:

> [snip]

> Well, my point was exactly that App Armor doesn't (as far as I know) do
> anything to enforce the argv[0] convention, nor would it in general
> prevent a confined program from making a symlink or hard link.  Even
> disregarding that, it seems very fragile in general to make an suid
> program (there would be no point in confining the execution of a
> non-suid program) perform essentially access control based on argv[0].

Note that by "confining the execution of a non-suid program", I mean
defining an App Armor profile that prevents the execution of a
particular non-suid program, unless of course the program file itself
contains secret information, which is irrelevant to this discussion.

-- 
Jeremy Maitin-Shepard
