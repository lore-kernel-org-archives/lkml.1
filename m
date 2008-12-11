Return-Path: <linux-kernel-owner+w=401wt.eu-S1758277AbYLKVnG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758277AbYLKVnG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 16:43:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757362AbYLKVmy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 16:42:54 -0500
Received: from mtagate2.de.ibm.com ([195.212.17.162]:60944 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757313AbYLKVmx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 16:42:53 -0500
In-Reply-To: <20081210040417.4EBBFFC362@magilla.sf.frob.com>
To: Roland McGrath <roland@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@tv-sign.ru>
MIME-Version: 1.0
Subject: Re: [PATCH, RFC] revert breakage from "tracehook: exec"
X-Mailer: Lotus Notes Build V70_M4_01112005 Beta 3NP January 11, 2005
From: Ulrich Weigand <Ulrich.Weigand@de.ibm.com>
Message-ID: <OF7B1822AA.D25240B4-ON4125751C.0076E13E-4125751C.00774705@de.ibm.com>
Date: Thu, 11 Dec 2008 22:42:48 +0100
X-MIMETrack: Serialize by Router on D12ML069/12/M/IBM(Release 8.0.1|February 07, 2008) at
 11/12/2008 22:42:49,
	Serialize complete at 11/12/2008 22:42:49
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath <roland@redhat.com> wrote on 12/10/2008 05:04:17 AM:

> Thanks for the report, good catch.  I've written a test case for the bug
> (I'll include it with the patch I post momentarily).  (Note to testers:
> this bug does not manifest on Fedora kernels.)

Hmm, I've definitely seen the problem on a F9 kernel.  I haven't tried
any more recent Fedora kernels ...

> My fix (next posting) leaves the call in search_binary_handler(),
> but makes it only on the outermost call (using bprm->recursion_depth).

This fix looks good to me as well.  Thanks!


Mit freundlichen Gruessen / Best Regards

Ulrich Weigand

-- 
  Dr. Ulrich Weigand | Phone: +49-7031/16-3727
  STSM, GNU compiler and toolchain for Linux on System z and Cell/B.E.
  IBM Deutschland Research & Development GmbH
  Vorsitzender des Aufsichtsrats: Martin Jetter | Geschäftsführung: Erich 
Baier
  Sitz der Gesellschaft: Böblingen | Registergericht: Amtsgericht 
Stuttgart, HRB 243294

