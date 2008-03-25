Return-Path: <linux-kernel-owner+w=401wt.eu-S1755071AbYCYMIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755071AbYCYMIz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 08:08:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753621AbYCYMIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 08:08:48 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:47332 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341AbYCYMIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 08:08:48 -0400
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] RWSEM: Rewrite rwsem.c and rwsem-spinlock.c more simply.
References: <alpine.LFD.1.00.0803250659530.18358@localhost.localdomain>
From: Andi Kleen <andi@firstfloor.org>
Date: 25 Mar 2008 13:08:45 +0100
In-Reply-To: <alpine.LFD.1.00.0803250659530.18358@localhost.localdomain>
Message-ID: <87skyfgg4y.fsf@basil.nowhere.org>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 25 Mar 2008 12:02:08.0256 (UTC) FILETIME=[0CD0F000:01C88E70]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Robert P. J. Day" <rpjday@crashcourse.ca> writes:

> Rewrite these source files more simply by deleting the superfluous
> "tsk" task_struct pointer and rephrasing in terms of the "current"
> task pointer.

This is likely a code pessimization because "current" is inline
assembler and many gcc versions cannot CSE it.

-Andi
