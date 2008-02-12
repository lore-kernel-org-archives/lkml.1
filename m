Return-Path: <linux-kernel-owner+w=401wt.eu-S1756910AbYBLTfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756910AbYBLTfT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 14:35:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751249AbYBLTfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 14:35:06 -0500
Received: from sinclair.provo.novell.com ([137.65.248.137]:6504 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153AbYBLTfE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 14:35:04 -0500
Message-Id: <47B1AD0B.BA47.005A.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Tue, 12 Feb 2008 12:28:27 -0700
From: "Gregory Haskins" <ghaskins@novell.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Mathieu Desnoyers" <mathieu.desnoyers@polymtl.ca>,
       "LKML" <linux-kernel@vger.kernel.org>,
       "linux-rt-users" <linux-rt-users@vger.kernel.org>
Subject: Re: [PATCH 1/2] add task migration_disable critical section
References: <20080212182512.10902.66459.stgit@novell1.haskins.net>
 <20080212183000.10902.97544.stgit@novell1.haskins.net>
 <Pine.LNX.4.58.0802121420470.21926@gandalf.stny.rr.com>
In-Reply-To: <Pine.LNX.4.58.0802121420470.21926@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On Tue, Feb 12, 2008 at  2:22 PM, in message
<Pine.LNX.4.58.0802121420470.21926@gandalf.stny.rr.com>, Steven Rostedt
<rostedt@goodmis.org> wrote: 

> On Tue, 12 Feb 2008, Gregory Haskins wrote:
> 
>> This patch adds a new critical-section primitive pair:
>>
>> "migration_disable()" and "migration_enable()"
> 
> This is similar to what Mathieu once posted:
> 
> http://lkml.org/lkml/2007/7/11/13
> 
> Not sure the arguments against (no time to read the thread again). But I'd
> recommend that you read it.
> 
> -- Steve

Indeed, thanks for the link!  At quick glance, the concept looks identical, though the implementations are radically different.

-Greg

