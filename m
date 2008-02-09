Return-Path: <linux-kernel-owner+w=401wt.eu-S1757163AbYBILkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757163AbYBILkp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 06:40:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753552AbYBILkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 06:40:37 -0500
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:24030 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752745AbYBILkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 06:40:36 -0500
Date: Sat, 9 Feb 2008 11:40:31 +0000
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: torvalds@osdl.org, linux-input@vger.kernel.org, dtor@mail.ru,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] keyboard notifier documentation
Message-ID: <20080209114031.GC4379@implementation>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Randy Dunlap <randy.dunlap@oracle.com>, torvalds@osdl.org,
	linux-input@vger.kernel.org, dtor@mail.ru,
	linux-kernel@vger.kernel.org
References: <20080209013322.GC4463@implementation> <20080208201253.46c068ed.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080208201253.46c068ed.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-Cloudmark-Analysis: v=1.0 c=1 a=vgUJB+MMWQXyFPPprAVJSw==:17 a=i5GPv-AnR8DnFnD64JYA:9 a=2r5TSfjIWfJnzaeqYznjyes3nZ8A:4 a=QJAqVYndk0IA:10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap, le Fri 08 Feb 2008 20:12:53 -0800, a écrit :
> On Sat, 9 Feb 2008 01:33:22 +0000 Samuel Thibault wrote:
> > +- 'vc' always provide the VC for which the keyboard event applies ;
> > +- 'down' is 1 for a key press event, 0 for a key release ;
> > +- 'shift' is the current modifier state, mask bit indexes are KG_* ;
> 
> No space before the ';' (3 times).

Well, as expected in French...  I'll fix that.

> > +For each kind of event but the last, the callback may return NOTIFY_STOP in
> > +order to "eat" the event: the notify loop is stopped and the keyboard event is
> > +dropped.
> > +
> > +I a rough C snippet, we have:
> 
>    In a rough (?)

Yes, rough as "something that a C compiler will never accept, but that
you, human, will make sense out of it".

Samuel
