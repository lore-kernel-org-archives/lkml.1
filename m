Return-Path: <linux-kernel-owner+w=401wt.eu-S1753710AbYGWNze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710AbYGWNze (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 09:55:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752393AbYGWNz0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 09:55:26 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55565 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbYGWNzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 09:55:25 -0400
Date: Wed, 23 Jul 2008 15:54:43 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Alex Nixon (Intern)" <Alex.Nixon@eu.citrix.com>
Cc: Andi Kleen <andi@firstfloor.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ian Campbell <Ian.Campbell@eu.citrix.com>,
       "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: Large increase in context switch rate
Message-ID: <20080723135443.GA20882@one.firstfloor.org>
References: <487E43D9.7080703@goop.org> <87mykgrxtv.fsf@basil.nowhere.org> <0E902970173AF84089673FA54B7FE78A329073@lonpexch01.citrite.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0E902970173AF84089673FA54B7FE78A329073@lonpexch01.citrite.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Seems to be a mystery why that patch is (seemingly) the culprit...anyone

Yes looks weird.

> have any ideas?  Maybe there's some other variable I'm not keeping
> constant?

Did you verify it was really that patch by unapplying/reapplying it?
Sometimes there are mistakes in the bisect process.

-Andi

