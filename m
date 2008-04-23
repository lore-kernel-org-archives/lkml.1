Return-Path: <linux-kernel-owner+w=401wt.eu-S1756528AbYDWNLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756528AbYDWNLV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 09:11:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752634AbYDWNLM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 09:11:12 -0400
Received: from sinclair.provo.novell.com ([137.65.248.137]:48839 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610AbYDWNLL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 09:11:11 -0400
Message-Id: <480EFD4E.BA47.005A.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Wed, 23 Apr 2008 07:11:42 -0600
From: "Gregory Haskins" <ghaskins@novell.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Dmitry Adamushko" <dmitry.adamushko@gmail.com>,
       <linux-kernel@vger.kernel.org>, <linux-rt-users@vger.kernel.org>
Subject: Re: [PATCH 2/2] sched: prioritize non-migratable tasks over
	migratableones
References: <20080423111313.4981.37345.stgit@novell1.haskins.net>
 <20080423111334.4981.19638.stgit@novell1.haskins.net>
 <Pine.LNX.4.58.0804230854210.23815@gandalf.stny.rr.com>
In-Reply-To: <Pine.LNX.4.58.0804230854210.23815@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On Wed, Apr 23, 2008 at  8:58 AM, in message
<Pine.LNX.4.58.0804230854210.23815@gandalf.stny.rr.com>, Steven Rostedt
<rostedt@goodmis.org> wrote: 


> 
> I'm not giving an Ack on this patch (not yet). My main concern here is
> that this is performing on a verge of policy change. As you stated, this
> is a known issue. One that can be avoided by giving RT tasks different
> priorities.  It is known that two tasks with the same priority fighting
> for the same CPUS (even if one is migratable and one is not) has
> non-deterministic behaviour.
> 
> This patch needs a bit of running through the grind to see what effects it
> has before going in.

Perfectly reasonable stance, Steve.  Thanks for the review!

-Greg

