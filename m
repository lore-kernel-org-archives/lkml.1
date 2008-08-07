Return-Path: <linux-kernel-owner+w=401wt.eu-S1754706AbYHGPRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706AbYHGPRv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 11:17:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752257AbYHGPRn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 11:17:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:37740 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbYHGPRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 11:17:43 -0400
Subject: Re: [ANNOUNCE] Merkey's Kernel Debugger
From: Peter Zijlstra <peterz@infradead.org>
To: jmerkey@wolfmountaingroup.com
Cc: Andi Kleen <andi@firstfloor.org>,
       Jason Wessel <jason.wessel@windriver.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <37747.166.70.238.45.1218113134.squirrel@webmail.wolfmountaingroup.com>
References: <17494.166.70.238.46.1217784156.squirrel@webmail.wolfmountaingroup.com>
	 <Pine.LNX.4.64.0808051140150.6309@anakin>
	 <33030.166.70.238.45.1217948565.squirrel@webmail.wolfmountaingroup.com>
	 <200808060133.10457.nickpiggin@yahoo.com.au>
	 <87r6926dsr.fsf@basil.nowhere.org> <4899DD9F.6020007@windriver.com>
	 <20080806185719.GE24801@one.firstfloor.org>
	 <37747.166.70.238.45.1218113134.squirrel@webmail.wolfmountaingroup.com>
Content-Type: text/plain
Date: Thu, 07 Aug 2008 17:17:31 +0200
Message-Id: <1218122251.8625.40.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-08-07 at 06:45 -0600, jmerkey@wolfmountaingroup.com wrote:

> Also, whoever wrote "/Documentation/volatiles_are_evil" must not have
> worked with the busted-ass GNU compiler that optimizes away global
> variables and busts SMP dependent code.  I am not going to remove the
> volatile declarations needed for SMP coordination in the debugger since
> the code breaks when removed.  GCC will cause massive breakage of SMP code
> if you do not declare certain variables as volatile.

Even with proper barrier() usage?


