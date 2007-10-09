Return-Path: <linux-kernel-owner+w=401wt.eu-S1753346AbXJILOA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346AbXJILOA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 07:14:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751409AbXJILNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 07:13:54 -0400
Received: from ns.suse.de ([195.135.220.2]:51238 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750850AbXJILNy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 07:13:54 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH -mm -v4 1/3] i386/x86_64 boot: setup data
Date: Tue, 9 Oct 2007 13:13:44 +0200
User-Agent: KMail/1.9.6
Cc: "Huang, Ying" <ying.huang@intel.com>, linux-mm@kvack.org,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>, akpm@linux-foundation.org,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org
References: <1191912010.9719.18.camel@caritas-dev.intel.com> <200710090125.27263.nickpiggin@yahoo.com.au>
In-Reply-To: <200710090125.27263.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200710091313.45003.ak@suse.de>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Care to add a line of documentation if you keep it in mm/memory.c?

It would be better to just use early_ioremap() (or ioremap())

That is how ACPI who has similar issues accessing its tables solves this.

-Andi
