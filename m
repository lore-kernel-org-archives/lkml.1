Return-Path: <linux-kernel-owner+w=401wt.eu-S1753917AbZKSRhL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917AbZKSRhL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 12:37:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753350AbZKSRhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 12:37:10 -0500
Received: from one.firstfloor.org ([213.235.205.2]:37403 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274AbZKSRhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 12:37:09 -0500
To: Richard Guenther <richard.guenther@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, feng.tang@intel.com,
       "Fr??d??ric Weisbecker" <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, jakub@redhat.com,
       gcc@gcc.gnu.org
Subject: Re: BUG: GCC-4.4.x changes the function frame on some functions
From: Andi Kleen <andi@firstfloor.org>
References: <alpine.LFD.2.00.0911181933540.24119@localhost.localdomain>
	<tip-887a29f59b93cf54e21814869a4ab6e80b6fa623@git.kernel.org>
	<20091119072040.GA23579@elte.hu>
	<alpine.LFD.2.00.0911191053390.24119@localhost.localdomain>
	<alpine.LFD.2.00.0911191423190.24119@localhost.localdomain>
	<alpine.LFD.2.00.0911191607440.24119@localhost.localdomain>
	<4B056820.1050104@zytor.com>
	<84fc9c000911190749y294381a2q16f4547991525cee@mail.gmail.com>
Date: Thu, 19 Nov 2009 18:37:11 +0100
In-Reply-To: <84fc9c000911190749y294381a2q16f4547991525cee@mail.gmail.com> (Richard Guenther's message of "Thu, 19 Nov 2009 16:49:57 +0100")
Message-ID: <87tywq4drs.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Guenther <richard.guenther@gmail.com> writes:
>
> It's likely because you have long long vars on the stack which is
> faster when they are aligned.

It's not faster for 32bit.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
