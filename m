Return-Path: <linux-kernel-owner+w=401wt.eu-S1755913AbYGIIKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913AbYGIIKg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 04:10:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753060AbYGIIKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 04:10:20 -0400
Received: from smtp113.mail.mud.yahoo.com ([209.191.84.66]:38215 "HELO
	smtp113.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752735AbYGIIKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 04:10:19 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=P5dwEiZXFJ5nBXr5FPIGqX0I95tNjAyLHMLngsoq7SXgDoNSqtW5RFuFOo6T24nh4juoUuu5xN6ezaWIIv8iar8Q4C/d3h4UL1l7cWELiJggZgxHyKyjJkWeYBWc45Vi6ItMGG+bVv+rnqH5D+a6Xs+2HZ6ksxhJl/TvTBnRLCs=  ;
X-YMail-OSG: ubdXDiwVM1nDdn3dtcYwTWEorNHIlP_88JSvQv9bVMABqFZNJm_ofJNPu73pIjpjIwQjZ.EcTDuLJk71ntLH3JK0XIjGUytjpRM29MDQexUdeNl9uS68Cb769B6y36BQyG4-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: "Gregory Haskins" <ghaskins@novell.com>
Subject: Re: [PATCH 2/3] sched: terminate newidle balancing once at least one task has moved over
Date: Wed, 9 Jul 2008 18:09:51 +1000
User-Agent: KMail/1.9.5
Cc: mingo@elte.hu, rostedt@goodmis.org, peterz@infradead.org, npiggin@suse.de,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
References: <20080627202444.3829.21595.stgit@lsg.lsg.lab.novell.com> <200807081500.18245.nickpiggin@yahoo.com.au> <48732751.BA47.005A.0@novell.com>
In-Reply-To: <48732751.BA47.005A.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807091809.52293.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 July 2008 22:37, Gregory Haskins wrote:
> >>> On Tue, Jul 8, 2008 at  1:00 AM, in message
>
> <200807081500.18245.nickpiggin@yahoo.com.au>, Nick Piggin
>
> <nickpiggin@yahoo.com.au> wrote:
> > On Saturday 28 June 2008 06:29, Gregory Haskins wrote:
> >> Inspired by Peter Zijlstra.
> >>
> >> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
> >
> > What happened to the feedback I sent about this?
> >
> > It is still nack from me.
>
> Ah yes.  Slipped through the cracks...sorry about that.
>
> What if we did "if (idle == CPU_NEWLY_IDLE && need_resched())" instead?

Isn't that exactly the same thing because any task will preempt the idle
thread?
