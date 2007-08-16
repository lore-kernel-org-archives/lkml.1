Return-Path: <linux-kernel-owner+w=401wt.eu-S933260AbXHPR2q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933260AbXHPR2q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 13:28:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758408AbXHPR2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 13:28:36 -0400
Received: from iriserv.iradimed.com ([72.242.190.170]:2647 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932262AbXHPR2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 13:28:25 -0400
Message-ID: <46C4893A.4050000@cfl.rr.com>
Date: Thu, 16 Aug 2007 13:28:26 -0400
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Kyle Moffett <mrmacman_g4@mac.com>,
       Michael Tharp <gxti@partiallystapled.com>, alan <alan@clueserver.org>,
       Marc Perkel <mperkel@yahoo.com>,
       LKML Kernel <linux-kernel@vger.kernel.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: Thinking outside the box on file systems
References: <106259.96671.qm@web52501.mail.re2.yahoo.com> <Pine.LNX.4.64.0708141546510.22494@blackbox.fnordora.org> <46C2F96D.5030908@partiallystapled.com> <20070815133021.GB9412@csclub.uwaterloo.ca> <ECFEFFF7-0210-4D16-B508-5284FCE58B28@mac.com> <46C33934.7060802@cfl.rr.com> <DE34FF90-3143-4978-BBC5-3CF74B8C3C07@mac.com> <46C3644C.9020102@cfl.rr.com> <87EEB1B3-7FFA-472C-B539-1A7AA2843869@mac.com> <46C37AD4.5060006@cfl.rr.com> <A93D7AFB-6883-48E4-96A9-CAD76E39132E@mac.com>            <46C4689C.8020702@cfl.rr.com> <17471.1187278162@turing-police.cc.vt.edu>
In-Reply-To: <17471.1187278162@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Aug 2007 17:28:35.0682 (UTC) FILETIME=[E0207420:01C7E02A]
X-TM-AS-Product-Ver: SMEX-7.5.0.1243-5.0.1021-15366.000
X-TM-AS-Result: No--9.963000-5.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu wrote:
> What happens if I do a 'mv /home /home1'?  Looks like more than a "relatively
> small" number.  A cold-cache 'find' takes a few minutes to wade through it all,
> so any solutions you come up with should beware of locking issues...

Then the directory is moved.... one dentry on disk needs changed to 
reflect the new name.
