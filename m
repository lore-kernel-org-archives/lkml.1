Return-Path: <linux-kernel-owner+w=401wt.eu-S1946011AbXBBSCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946011AbXBBSCq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 13:02:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946026AbXBBSCp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 13:02:45 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:52379 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946013AbXBBSCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 13:02:44 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Luigi Genoni" <luigi.genoni@pirelli.com>
Cc: <akpm@osdl.org>, <linux-kernel@vger.kernel.org>
Subject: Re: System crash after "No irq handler for vector" linux 2.6.19
References: <200701221116.13154.luigi.genoni@pirelli.com>
	<200701311549.22512.luigi.genoni@pirelli.com>
	<m1veim739m.fsf@ebiederm.dsl.xmission.com>
	<200702021848.55921.luigi.genoni@pirelli.com>
Date: Fri, 02 Feb 2007 11:02:01 -0700
In-Reply-To: <200702021848.55921.luigi.genoni@pirelli.com> (Luigi Genoni's
	message of "Fri, 2 Feb 2007 18:48:55 +0100")
Message-ID: <m1ejp85tgm.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Luigi Genoni" <luigi.genoni@pirelli.com> writes:

> I tested the patch, but I could not really stress the HW.
> anyway no crash, but load average is somehow abnormal, higher than it should 
> be.

Thanks.  Did you get any nasty messages about "No irq handler for vector?"
If not then you never even hit the problem condition.

Given how rare the trigger condition is it would probably take force
irq migration to even trigger the "No irq handler for vector message".

That patch I'm not really worried about, I've tested it and it meets
the obviously correct condition :)  But it should enable people to
not be afraid of IRQ migration.

I'm slowly working my way towards a real fix.  I know what I have to code,
now I just have to figure out how. :)

Eric
