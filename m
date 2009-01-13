Return-Path: <linux-kernel-owner+w=401wt.eu-S1758944AbZAMFrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758944AbZAMFrj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 00:47:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753991AbZAMFr3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 00:47:29 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:63992 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446AbZAMFr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 00:47:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=MMtZ8tgjpspMwRWoGR/bcXNE6soK6DweK3hboq7OpFeOk8sR1sjFT4rRjPwmgk0Ee/
         UgOkNd3OL6bN6WY+axRrqdZ1R1V2f7pLM1Su+eQJfRSLfGi0kZG5gDzmIwLvrbZIrRjK
         6f3SBhQh4Uz6HbbNlS6Oq55r5IYSj6o7Ly+XM=
Message-ID: <b6a2187b0901122147o45890cd4lfb6ba7b2908e6ae7@mail.gmail.com>
Date: Tue, 13 Jan 2009 13:47:27 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [Bug #12422] 2.6.28-git can't resume from str
Cc: "Christian Borntraeger" <borntraeger@de.ibm.com>,
       "Daniel Drake" <dsd@gentoo.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>,
       "Phil Dibowitz" <phil@ipom.com>
In-Reply-To: <b6a2187b0901122028w3f85fc9aj41d7c8ac44adb2ed@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <XU-8icArWLM.A.UpG.8GfaJB@chimera>
	 <b6a2187b0901110813s5429573cm7d78f39e288f70a3@mail.gmail.com>
	 <20090111162949.GA15338@elte.hu>
	 <200901111736.24350.borntraeger@de.ibm.com>
	 <20090111163904.GA21806@elte.hu>
	 <b6a2187b0901110856j3f2ff6fepc19a816178e38a95@mail.gmail.com>
	 <20090111180714.GB15326@elte.hu>
	 <b6a2187b0901121720s1f9b12ednb76a90dcc7eddc81@mail.gmail.com>
	 <alpine.LFD.2.00.0901121807070.6528@localhost.localdomain>
	 <b6a2187b0901122028w3f85fc9aj41d7c8ac44adb2ed@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 11, 2009 at 7:16 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:

> The following bug entry is on the current list of known regressions
> from 2.6.28.  Please verify if it still should be listed and let me know
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=12422
> Subject         : 2.6.28-git can't resume from str
> Submitter       : Jeff Chua <jeff.chua.linux@gmail.com>
> Date            : 2009-01-10 1:39 (2 days old)
> References      : http://marc.info/?l=linux-kernel&m=123155157909282&w=4

Fixed by reverting a0d4922da2e4ccb0973095d8d29f36f6b1b5f703.
7503bfbae89eba07b46441a5d1594647f6b8ab7d has already been reverted in
the Linus's latest git tree.

Thanks everyone for all the help.

Jeff.
