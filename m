Return-Path: <linux-kernel-owner+w=401wt.eu-S1753174AbZGJGwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174AbZGJGwS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 02:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751055AbZGJGwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 02:52:05 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45082 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750861AbZGJGwD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 02:52:03 -0400
Date: Fri, 10 Jul 2009 08:51:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Len Brown <lenb@kernel.org>
Cc: x86@kernel.org, sfi-devel@simplefirmware.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, Feng Tang <feng.tang@intel.com>,
       Len Brown <len.brown@intel.com>
Subject: Re: [PATCH 06/12] ACPI, x86: remove ACPI dependency on some
	IO-APIC routines
Message-ID: <20090710065142.GH22218@elte.hu>
References: <8e4a93858bce74ed3080dd607aa471023f1a2737.1247025117.git.len.brown@intel.com> <bf8ea7cda3ad3f287f1c9164d366a94eae07a4a5.1247025117.git.len.brown@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bf8ea7cda3ad3f287f1c9164d366a94eae07a4a5.1247025117.git.len.brown@intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Len Brown <lenb@kernel.org> wrote:

> From: Feng Tang <feng.tang@intel.com>
> 
> Both ACPI and SFI x86 systems will use these io_apic routines:
> 
> uniq_ioapic_id(u8 id);

While touching this code please also fix the misnomer:

 s/uniq_ioapic_id/unique_ioapic_id

Thanks,

	Ingo
