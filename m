Return-Path: <linux-kernel-owner+w=401wt.eu-S1755237AbYINP14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237AbYINP14 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 11:27:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752623AbYINP1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 11:27:49 -0400
Received: from casper.infradead.org ([85.118.1.10]:43674 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752396AbYINP1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 11:27:48 -0400
Date: Sun, 14 Sep 2008 08:27:37 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Ulrich Drepper" <drepper@gmail.com>
Cc: "Pavel Machek" <pavel@suse.cz>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, dwmw2@infradead.org, drepper@redhat.com,
       mingo@elte.hu, tglx@tglx.de
Subject: Re: [PATCH 12/13] hrtimer: create a "timer_slack" field in the task
 struct
Message-ID: <20080914082737.3ce5661f@infradead.org>
In-Reply-To: <a36005b50809140821w2caeb810p431cf5625b0297f5@mail.gmail.com>
References: <20080901160343.75a89ec9@infradead.org>
	<20080901161423.59ebf2fc@infradead.org>
	<20080902100439.GA11383@elf.ucw.cz>
	<20080902060323.70245b83@infradead.org>
	<20080908132713.GA18486@elf.ucw.cz>
	<20080908064002.7abc2a22@infradead.org>
	<20080908141555.GB31784@elf.ucw.cz>
	<a36005b50809140821w2caeb810p431cf5625b0297f5@mail.gmail.com>
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

On Sun, 14 Sep 2008 08:21:26 -0700
"Ulrich Drepper" <drepper@gmail.com> wrote:

> The prctl() way plus a default non-zero value is the best way for
> legacy apps.  And you'll hopefully get your wish that apps will take
> fate into their own hand by specifying the slack themselves.  Arjan's
> proposal also introduces new poll/select-like interface which take the
> additional slack value (at least that's what we discussed before).

I have not posted the code for this yet (the patch set is huge
already :0) but yes it's going to happen.
You and I do need to figure out what a sensible interface will be for
these ;-)


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
