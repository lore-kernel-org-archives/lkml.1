Return-Path: <linux-kernel-owner+w=401wt.eu-S1761681AbYBWSnL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761681AbYBWSnL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 13:43:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757526AbYBWSm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 13:42:56 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:52931 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756960AbYBWSmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 13:42:55 -0500
Date: Sat, 23 Feb 2008 10:40:38 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       sandmann@redhat.com, tglx@tglx.de, hpa@zytor.com,
       John Levon <levon@movementarian.org>
Subject: Re: [PATCH] x86: add the debugfs interface for the sysprof tool
Message-Id: <20080223104038.0599a30d.akpm@linux-foundation.org>
In-Reply-To: <20080223113724.GB31304@elte.hu>
References: <20080219123756.6261c13c@laptopd505.fenrus.org>
	<20080223001130.d8922136.akpm@linux-foundation.org>
	<20080223113724.GB31304@elte.hu>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Feb 2008 12:37:24 +0100 Ingo Molnar <mingo@elte.hu> wrote:

> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > > Sysprof needs a 200 line kernel module to do it's work, this module 
> > > puts some simple profiling data into debugfs.
> > > 
> > > ...
> > 
> > Seems a poor idea to me.  Sure, oprofile is "hard to set up", but not 
> > if your distributor already did it for you.
> 
> two things.
> 
> Firstly, this isnt an oprofile replacement, this is a pretty separate 
> concept. Sysprof is more of a tracer than a profiler.

I don't understand the distinction and I don't see what sysprof (as defined
by its kernel->userspace interface) can do which oprofile cannot.

This is yet another thing which should have been in the damned changlog but
wasn't.

> (and we are 
> currently working on merging it into ftrace)

I think you should drop it and we should see a replacement patch which has
all the bugs, inefficiencies and deficiencies addressed and which has a
vaguely respectable description.

> Secondly, real developers who tune user-space code disagree with your 
> characterisation of oprofile being easy to use.

afacit all of these criticisms surround oprofile's userspace tools only.
