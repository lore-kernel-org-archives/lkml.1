Return-Path: <linux-kernel-owner+w=401wt.eu-S1756575AbZBSUZq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575AbZBSUZq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 15:25:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753923AbZBSUZh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 15:25:37 -0500
Received: from mail-in-17.arcor-online.net ([151.189.21.57]:44613 "EHLO
	mail-in-17.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753897AbZBSUZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 15:25:36 -0500
X-DKIM: Sendmail DKIM Filter v2.6.0 mail-in-02.arcor-online.net C59063FE374
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: [PATCH] Add *.rej to .gitignore
To: Ingo Molnar <mingo@elte.hu>, jeremy@goop.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       sam@ravnborg.org, gitster@pobox.com, caglar@pardus.org.tr,
       David Miller <davem@davemloft.net>
Reply-To: 7eggert@gmx.de
Date: Thu, 19 Feb 2009 21:25:28 +0100
References: <c6Eh1-7Og-19@gated-at.bofh.it> <c6GLO-3xO-35@gated-at.bofh.it> <c6IaO-60k-5@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1LaFSb-0002J5-6Z@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> wrote:
> * David Miller <davem@davemloft.net> wrote:
>> From: Jeremy Fitzhardinge <jeremy@goop.org>

>> > *.rej files really are unwanted.  If there are any .rej files, they can be
>> > found by some other means (perhaps git itself could warn when committing
>> > with *.rej files present, or add some distinct notion of "ignored files" vs
>> > "never commit" files).
>> > 
>> > (This effectively reverts 1f5d3a6b6532e25a5cdf1f311956b2b03d343a48)
>> > 
>> > Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>> 
>> I don't know about this.
>> 
>> I really want to know if there are reject files there if I am
>> checking to see if my tree is clean.
[...]
> Well, it depends on the workflow. You are making the assumption
> that everyone is using your workflow, and you are judging them
> based on that false assumption.

If different users need different .gitignores, you need a per-user setting.
Let there be ~/.git/gitignore.

