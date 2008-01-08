Return-Path: <linux-kernel-owner+w=401wt.eu-S1758919AbYAHOjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758919AbYAHOjT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 09:39:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755288AbYAHOjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 09:39:09 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:59422 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753455AbYAHOjG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 09:39:06 -0500
To: hch@infradead.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, takedakn@nttdata.co.jp
Subject: Re: [TOMOYO #6 02/21] Add struct vfsmount to struct task_struct.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20080108094903.484613061@nttdata.co.jp>
	<20080108094956.610620186@nttdata.co.jp>
	<20080108140902.GA12238@infradead.org>
In-Reply-To: <20080108140902.GA12238@infradead.org>
Message-Id: <200801082339.CGC57333.OJFVHMSFOLFtOQ@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Tue, 8 Jan 2008 23:39:03 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Christoph Hellwig wrote:
> Just FYI:  A NACK to such an addition doesn't simply go away by
> ignoring it.
Excuse me. What NACK is remaining?

About the below comments?
> > NACK to this. Passing function parameters through the task_struct is
> > definitely not an acceptable hack
> 
> Exactly.  Having a vfsmount other than the current processes root or
> current working directory in task_struct doesn't make any sense.

I explained that this approach pushes the parameter on the stack memory
and behaves as if the parameter was passed by function calls.
http://lkml.org/lkml/2007/11/19/80

But if this approach is still unacceptable,
please discuss and adopt AppArmor's patches as soon as possible.
Both AppArmor and TOMOYO needs vfsmount parameters, but
I'm sad to see no comments on AppArmor's vfsmount patches.

Regards.
