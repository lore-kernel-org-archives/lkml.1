Return-Path: <linux-kernel-owner+w=401wt.eu-S1760480AbXKMFs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760480AbXKMFs1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 00:48:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750765AbXKMFsS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 00:48:18 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:41763 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbXKMFsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 00:48:17 -0500
Date: Tue, 13 Nov 2007 11:30:38 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: "Paul Menage" <menage@google.com>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: Revert for cgroups CPU accounting subsystem patch
Message-ID: <20071113060038.GC3359@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <6599ad830711122125u576e85a6w428466a0ab46dbc6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6599ad830711122125u576e85a6w428466a0ab46dbc6@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 12, 2007 at 09:25:32PM -0800, Paul Menage wrote:
> Hi Linus,
> 
> Please can you revert commit 62d0df64065e7c135d0002f069444fbdfc64768f,
> entitled "Task Control Groups: example CPU accounting subsystem" ?

Hi Paul,
	On second thoughts, this may be a usefull controller of its own.
Say I just want to "monitor" usage (for accounting purpose) of a group of 
tasks, but don't want to control their cpu consumption, then cpuacct 
controller would come in handy.

-- 
Regards,
vatsa
