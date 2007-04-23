Return-Path: <linux-kernel-owner+w=401wt.eu-S1751649AbXDWUCe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751649AbXDWUCe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 16:02:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751696AbXDWUCe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 16:02:34 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34422 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751649AbXDWUCe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 16:02:34 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Satyam Sharma" <satyam.sharma@gmail.com>
Subject: Re: [RFC][PATCH -mm 2/3] freezer: Introduce freezer_flags
Date: Mon, 23 Apr 2007 21:06:28 +0200
User-Agent: KMail/1.9.5
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Ingo Molnar" <mingo@elte.hu>,
       ego@in.ibm.com, "Oleg Nesterov" <oleg@tv-sign.ru>,
       linux-kernel@vger.kernel.org, vatsa@in.ibm.com, paulmck@us.ibm.com,
       pavel@ucw.cz
References: <20070419120131.GB13435@in.ibm.com> <200704222139.27128.rjw@sisk.pl> <a781481a0704222109t5c92e4d6t280c21b256945ac8@mail.gmail.com>
In-Reply-To: <a781481a0704222109t5c92e4d6t280c21b256945ac8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704232106.29983.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Monday, 23 April 2007 06:09, Satyam Sharma wrote:
> Hi Rafael,
> 
[--snip--]
> 
> Also, I do have several gripes against the naming of some of these functions:
> 
> >  static inline int freezing(struct task_struct *p)
> 
> This could be called task_should_freeze().
> 
> >  /*
> > - * Sometimes we may need to cancel the previous 'freeze' request
> > + * Cancel the previous 'freeze' request
> >   */
> >  static inline void do_not_freeze(struct task_struct *p)
> 
> This definitely needs to be undo_freeze() or unfreeze().
> do_not_freeze() sounds like what freeze_exempt() does.
> 
> >  static inline void frozen_process(struct task_struct *p)
> 
> frozen_process() sounds like what frozen() is supposed to do. This
> could instead be mark_task_frozen(), or even mark_frozen(), because
> only the current task can ever mark *itself* frozen before freezing
> itself.
> 
> >  static inline void freezer_do_not_count(void)
> >  static inline void freezer_count(void)
> 
> These could be called freezer_skip() and freezer_do_not_skip(). Better
> to stick to consistent naming / terminology.

Well, I agree that the names are not the best ones, but I'd like to avoid
changing the existing names in this particular patch.

We can change them later, on top of it.

Greetings,
Rafael
