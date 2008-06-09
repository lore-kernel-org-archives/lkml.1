Return-Path: <linux-kernel-owner+w=401wt.eu-S1754771AbYFIP5B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771AbYFIP5B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 11:57:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751891AbYFIP4w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 11:56:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33346 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751765AbYFIP4v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 11:56:51 -0400
Message-ID: <484D51CE.60709@redhat.com>
Date: Mon, 09 Jun 2008 12:52:46 -0300
From: Glauber Costa <gcosta@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "Maciej W. Rozycki" <macro@linux-mips.org>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       tglx@linutronix.de, mingo@elte.hu, hugh@veritas.com
Subject: Re: [PATCH 11/15] x86: move enabling of io_apic to prepare_cpus
References: <1213021018-14159-1-git-send-email-gcosta@redhat.com> <1213021018-14159-2-git-send-email-gcosta@redhat.com> <1213021018-14159-3-git-send-email-gcosta@redhat.com> <1213021018-14159-4-git-send-email-gcosta@redhat.com> <1213021018-14159-5-git-send-email-gcosta@redhat.com> <1213021018-14159-6-git-send-email-gcosta@redhat.com> <1213021018-14159-7-git-send-email-gcosta@redhat.com> <1213021018-14159-8-git-send-email-gcosta@redhat.com> <1213021018-14159-9-git-send-email-gcosta@redhat.com> <1213021018-14159-10-git-send-email-gcosta@redhat.com> <1213021018-14159-11-git-send-email-gcosta@redhat.com> <1213021018-14159-12-git-send-email-gcosta@redhat.com> <Pine.LNX.4.55.0806091620250.26593@cliff.in.clinika.pl>
In-Reply-To: <Pine.LNX.4.55.0806091620250.26593@cliff.in.clinika.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maciej W. Rozycki wrote:
> On Mon, 9 Jun 2008, Glauber Costa wrote:
> 
>> Do it, instead of keeping in io_apic_32.c. This is the way x86_64
>> already does.
> 
>  This change looks wrong -- is native_smp_prepare_cpus() at all run on
> !CONFIG_SMP?  I don't think so.  You have to do this differently.
You're right.

I'll update this one.
