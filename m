Return-Path: <linux-kernel-owner+w=401wt.eu-S1755209AbYINQOq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209AbYINQOq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 12:14:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751992AbYINQOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 12:14:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:50983 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbYINQOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 12:14:37 -0400
Date: Sun, 14 Sep 2008 09:14:22 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Ulrich Drepper" <drepper@gmail.com>
Cc: "Pavel Machek" <pavel@suse.cz>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, dwmw2@infradead.org, drepper@redhat.com,
       mingo@elte.hu, tglx@tglx.de
Subject: Re: [PATCH 12/13] hrtimer: create a "timer_slack" field in the task
 struct
Message-ID: <20080914091422.0aaaee8c@infradead.org>
In-Reply-To: <a36005b50809140904h690d00b0sa66f166a64850114@mail.gmail.com>
References: <20080901160343.75a89ec9@infradead.org>
	<20080901161423.59ebf2fc@infradead.org>
	<20080902100439.GA11383@elf.ucw.cz>
	<20080902060323.70245b83@infradead.org>
	<20080908132713.GA18486@elf.ucw.cz>
	<20080908064002.7abc2a22@infradead.org>
	<20080908141555.GB31784@elf.ucw.cz>
	<a36005b50809140821w2caeb810p431cf5625b0297f5@mail.gmail.com>
	<20080914155744.GA4845@ucw.cz>
	<a36005b50809140904h690d00b0sa66f166a64850114@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Sep 2008 09:04:08 -0700
"Ulrich Drepper" <drepper@gmail.com> wrote:

> 
> You cannot really use the environment for anything meaningful.
> Especially for this case, you couldn't change the setting for a
> running process.  What a fully-userlevel implementation would have to
> do is read the value from a file and monitor the file for changes for
> every new poll/select call.  That's a huge cost.

in addition, the value really is per thread, not per process, and how
do you want to do that with env. variables?

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
