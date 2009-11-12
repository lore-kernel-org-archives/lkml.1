Return-Path: <linux-kernel-owner+w=401wt.eu-S1754043AbZKLSO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043AbZKLSO2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 13:14:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753853AbZKLSO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 13:14:28 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44972 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753907AbZKLSO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 13:14:27 -0500
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [GIT PULL] percpu fixes for 2.6.32-rc6
From: Andi Kleen <andi@firstfloor.org>
References: <alpine.LFD.2.01.0911101042140.31845@localhost.localdomain>
	<4AF9BE3A.40409@kernel.org> <20091110193705.GA9011@elte.hu>
	<4AF9C402.9040800@kernel.org>
	<alpine.LFD.2.01.0911101338190.31845@localhost.localdomain>
	<4AFA35CB.5030801@kernel.org> <20091111113147.GB7487@elte.hu>
	<4AFAAC32.4020104@kernel.org> <20091111195751.GA13574@elte.hu>
	<4AFBDF43.3010703@kernel.org> <20091112103639.GB24684@elte.hu>
	<4AFBEA4B.4070100@kernel.org>
	<alpine.LFD.2.01.0911120714260.31845@localhost.localdomain>
Date: Thu, 12 Nov 2009 19:14:26 +0100
In-Reply-To: <alpine.LFD.2.01.0911120714260.31845@localhost.localdomain> (Linus Torvalds's message of "Thu, 12 Nov 2009 07:17:47 -0800 (PST)")
Message-ID: <871vk37gql.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:
>
> 'checkpatch' is the major reason for them, but I think we've fixed 
> checkpath long ago to not warn about long lines if they are due to a long 
> string.

It still warns as of 2.6.36rc6 (I hit that all the time):

WARNING: line over 80 characters
#14: FILE: kernel/sys.c:1659:
+"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
