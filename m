Return-Path: <linux-kernel-owner+w=401wt.eu-S1751123AbZH1BRK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751123AbZH1BRK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 21:17:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751022AbZH1BRJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 21:17:09 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:34449 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbZH1BRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 21:17:08 -0400
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: David Dillow <dave@thedillows.org>,
       Michael Riepe <michael.riepe@googlemail.com>,
       Michael Buesch <mb@bu3sch.de>, Rui Santos <rsantos@grupopie.com>,
       Michael B??ker <m.bueker@berlin.de>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH] r8169: Reduce looping in the interrupt handler.
References: <m1k50r8u4p.fsf@fess.ebiederm.org>
	<20090825221903.GA13630@electric-eye.fr.zoreil.com>
	<m1iqgbknun.fsf_-_@fess.ebiederm.org>
	<1251294974.14241.9.camel@obelisk.thedillows.org>
	<1251295175.14241.11.camel@obelisk.thedillows.org>
	<m11vmy737x.fsf@fess.ebiederm.org>
	<20090826213024.GA20428@electric-eye.fr.zoreil.com>
	<m1hbvu45jq.fsf@fess.ebiederm.org>
	<20090827052423.GA1709@electric-eye.fr.zoreil.com>
	<m1ocq1ke9u.fsf@fess.ebiederm.org>
	<20090827232024.GA30119@electric-eye.fr.zoreil.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 27 Aug 2009 18:17:01 -0700
In-Reply-To: <20090827232024.GA30119@electric-eye.fr.zoreil.com> (Francois Romieu's message of "Fri\, 28 Aug 2009 01\:20\:24 +0200")
Message-ID: <m1d46gka9e.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: romieu@fr.zoreil.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, m.bueker@berlin.de, rsantos@grupopie.com, mb@bu3sch.de, michael.riepe@googlemail.com, dave@thedillows.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Francois Romieu <romieu@fr.zoreil.com> writes:

> Eric W. Biederman <ebiederm@xmission.com> :
> [...]
>> Sounds good.
>
> Gah, I was not able to test it with a decent packet load. Patch below against
> the current tree:

This kills the loop which was my concern.

I will double check it works on my configuration.
Then we have the question of does it work for those folks who have cards
where the msi appeared to get lost.

David any chance you can test this patch?

Eric
