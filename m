Return-Path: <linux-kernel-owner+w=401wt.eu-S1763502AbYBWUoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763502AbYBWUoR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 15:44:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754259AbYBWUoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 15:44:08 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:50362 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752977AbYBWUoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 15:44:07 -0500
Date: Sat, 23 Feb 2008 12:42:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Soeren Sandmann <sandmann@daimi.au.dk>
Cc: John Levon <levon@movementarian.org>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       tglx@tglx.de, hpa@zytor.com
Subject: Re: [PATCH] x86: add the debugfs interface for the sysprof tool
Message-Id: <20080223124234.665c01a7.akpm@linux-foundation.org>
In-Reply-To: <ye8ejb3e8ef.fsf@camel10.daimi.au.dk>
References: <20080219123756.6261c13c@laptopd505.fenrus.org>
	<20080223001130.d8922136.akpm@linux-foundation.org>
	<20080223113724.GB31304@elte.hu>
	<20080223135335.GA28464@totally.trollied.org.uk>
	<ye8ejb3e8ef.fsf@camel10.daimi.au.dk>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 Feb 2008 21:15:52 +0100 Soeren Sandmann <sandmann@daimi.au.dk> wrote:

> It was only later I tried oprofile and found it not only much more
> difficult to use, but also much less useful when I did get it to work.

Could we please be very careful to not conflate oprofile's kernel support
with oprofile userspace?  For the purposes of this discussion the
distinction is most important.

I _assume_ you're referring to oprofile userspace which I agree is
user-hostile.  It is a rich area for others to improve upon.  In so doing
they might even have a need to change oprofile's kernel code.  But simply
giving up and going off and implementing some parallel kernel code is an
utter last resort and should only be done after it has been shown that the
current kernel code is unfixable.
