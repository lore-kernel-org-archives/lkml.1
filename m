Return-Path: <linux-kernel-owner+w=401wt.eu-S1765901AbXGZMFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765901AbXGZMFw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 08:05:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754393AbXGZMFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 08:05:46 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35926 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754338AbXGZMFp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 08:05:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Parag Warudkar" <parag.warudkar@gmail.com>
Subject: Re: 2.6.22 - Suspend and Weird Load Averages
Date: Thu, 26 Jul 2007 14:14:22 +0200
User-Agent: KMail/1.9.5
Cc: "Pavel Machek" <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
       "Nigel Cunningham" <ncunningham@linuxmail.org>
References: <469E1AFE.7010108@gmail.com> <20070725133919.GA9256@ucw.cz> <82e4877d0707251240t4c5dcff7wb3c7523e577ddb76@mail.gmail.com>
In-Reply-To: <82e4877d0707251240t4c5dcff7wb3c7523e577ddb76@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707261414.23430.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 25 July 2007 21:40, Parag Warudkar wrote:
> Hi Pavel!
> 
> On 7/25/07, Pavel Machek <pavel@ucw.cz> wrote:
> 
> > Known, and Rafael/Nigel have patches to fix that.
> 
> Thanks for the info - Rafael/Nigel do you have any patches for me to
> try/modify -

Well, I don't.

> I am just curious to see what approach the patches take 
> to fix this - I had started thinking about TASK_SUSPENDED which would
> be equivalent to TASK_UNINTERRUPTIBLE for all purposes except load
> calculation (not counted in nr_uninterruptible) but somehow I think
> there might be a less intrusive / more correct way to do this.

We wanted to save the pre-suspend load averages and restore them during the
resume.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
