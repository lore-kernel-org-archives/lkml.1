Return-Path: <linux-kernel-owner+w=401wt.eu-S1758265AbYHZLHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758265AbYHZLHi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 07:07:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753924AbYHZLH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 07:07:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48203 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753231AbYHZLH3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 07:07:29 -0400
Date: Tue, 26 Aug 2008 13:07:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frans Meulenbroeks <fransmeulenbroeks@gmail.com>
Cc: Avi Kivity <avi@qumranet.com>, Pavel Machek <pavel@suse.cz>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] x86: default to reboot via ACPI
Message-ID: <20080826110715.GA26204@elte.hu>
References: <1219659087-17536-1-git-send-email-avi@qumranet.com> <20080826095032.GA309@elf.ucw.cz> <48B3D579.40502@qumranet.com> <ac9c93b10808260403ga9f6e13v4792bb2c13dfc2bf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac9c93b10808260403ga9f6e13v4792bb2c13dfc2bf@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frans Meulenbroeks <fransmeulenbroeks@gmail.com> wrote:

> 2008/8/26 Avi Kivity <avi@qumranet.com>:
> 
> > It seems excessive.  Most machines will hardly run without acpi.
> 
> Well, I'm fairly sure that most of the systems running linux (or some 
> variant like uclinux), do not support acpi.
> 
> Linux is used a lot in embedded systems (like routers and NAS-es and 
> probably set-top boxes). I guess the # of embedded systems with some 
> linux flavour on it is substantially bigger than the desktop systems. 
> Most of these are ARM or MIPS based and do not support ACPI.

... which is not an issue in this particular discussion, which was about 
x86 with ACPI support enabled and available, whether in that case (and 
only in that case) we should first try the ACPI reboot ports (that the 
ACPI descriptors advertise) before also trying the other methods (kdb, 
bios, triple fault, etc.) to reboot the box.

	Ingo
