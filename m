Return-Path: <linux-kernel-owner+w=401wt.eu-S1753353AbYGWLtF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353AbYGWLtF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 07:49:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751390AbYGWLsz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 07:48:55 -0400
Received: from mail-in-11.arcor-online.net ([151.189.21.51]:43715 "EHLO
	mail-in-11.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751223AbYGWLsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 07:48:54 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: [RFC] schedule_timeout_range()
To: Nick Piggin <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       arjan@infradead.org, David Woodhouse <dwmw2@infradead.org>
Reply-To: 7eggert@gmx.de
Date: Wed, 23 Jul 2008 13:52:06 +0200
References: <aSgqr-EJ-15@gated-at.bofh.it> <aShcU-3uj-11@gated-at.bofh.it> <aShw5-4ai-9@gated-at.bofh.it> <aShPs-4IY-1@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8Bit
Message-Id: <E1KLct4-0001Wx-O9@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> The only thing I dislike about explicit times is that when a driver or
> someone doesn't _really_ know how much to specify. Do you say 10s, 100s?
> It shouldn't be arbitrary, but we should have a few constants I think.

You'd replace "Should I use 10 or 100 seconds?" with "Should I use
TIMEOUT_10_SEC or TIMEOUT_100_SEC?", while replacing "I want 40 seconds!"
with "Danmed, I want 40 seconds, but that's not an option!".

BTW: If you don't know about which timeout you should use, you should think
about mowing the lawn instead. ¢¢


