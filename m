Return-Path: <linux-kernel-owner+w=401wt.eu-S932399AbXFEOpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932399AbXFEOpS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 10:45:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932234AbXFEOoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 10:44:15 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:32503 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764439AbXFEOoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 10:44:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:from;
        b=WCwjuxnJ7QDCWXPbJWzaxa+QHJSIIko2nwYh2ENw18RYJkklVXI9deBqfvj+Pwtd5l0xDlub2YyA+zodpKkqxKxkSyYjnLp1aAKPy+9QPj7Nh7Fsq7npzASzC04E7Hz0Rcx57dGsEV8dHQDm3OAK7WV+xU0KWJlWldLYh/BpKUA=
Message-ID: <466576AB.1090806@googlemail.com>
Date: Tue, 05 Jun 2007 16:43:55 +0200
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
       linux-wireless@vger.kernel.org, Michael Buesch <mb@bu3sch.de>,
       Maximilian Engelhardt <maxi@daemonizer.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Gary Zambrano <zambrano@broadcom.com>, Samuel Ortiz <samuel@sortiz.org>,
       Andrey Borzenkov <arvidjaar@mail.ru>,
       Paulo Pereira <pfmp.404@gmail.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Samuel Ortiz <samuel@sortiz.org>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       linux-pcmcia@lists.infradead.org,
       Robert de Rooy <robert.de.rooy@gmail.com>, Alan Cox <alan@redhat.com>,
       Tejun Heo <htejun@gmail.com>
Subject: Re: [3/5] 2.6.22-rc4: known regressions
References: <46657407.1000108@googlemail.com>
In-Reply-To: <46657407.1000108@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is a list of some known regressions in 2.6.22-rc4.

Feel free to add new regressions/remove fixed etc.
http://kernelnewbies.org/known_regressions



Networking

Subject    : list_add corruption. prev->next should be next (f7d28794), but was f0df8ed4 (prev=f0df8ed4) Kernel Bug at lib/list_debug.c:33
References : http://bugzilla.kernel.org/show_bug.cgi?id=8561
Submitter  : Paulo Pereira <pfmp.404@gmail.com>
Handled-By : Alan Stern <stern@rowland.harvard.edu>
Status     : problem is being debugged

Subject    : no irda0 interface (2.6.21 was OK), smsc does not find chip
References : http://lkml.org/lkml/2007/6/3/16
Submitter  : Andrey Borzenkov <arvidjaar@mail.ru>
Handled-By : Samuel Ortiz <samuel@sortiz.org>
             Bjorn Helgaas <bjorn.helgaas@hp.com>
Status     : problem is being debugged

Subject    : b44: regression in 2.6.22
References : http://lkml.org/lkml/2007/5/27/108
Submitter  : Maximilian Engelhardt <maxi@daemonizer.de>
Handled-By : Gary Zambrano <zambrano@broadcom.com>
             Michael Buesch <mb@bu3sch.de>
             Thomas Gleixner <tglx@linutronix.de>
Status     : problem is being debugged



PCMCIA

Subject    : libata and legacy ide pcmcia failure
References : http://lkml.org/lkml/2007/5/17/305
Submitter  : Robert de Rooy <robert.de.rooy@gmail.com>
Status     : Unknown



Regards,
Michal

--
"Najbardziej brakowa³o mi twojego milczenia."
-- Andrzej Sapkowski "Co¶ wiêcej"

