Return-Path: <linux-kernel-owner+w=401wt.eu-S1757472AbYAJLP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757472AbYAJLP1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 06:15:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753154AbYAJLPT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 06:15:19 -0500
Received: from ns1.suse.de ([195.135.220.2]:58690 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752190AbYAJLPS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 06:15:18 -0500
Date: Thu, 10 Jan 2008 12:15:15 +0100
From: Andi Kleen <ak@suse.de>
To: Adrian Bunk <bunk@kernel.org>
Cc: Andi Kleen <ak@suse.de>, rjw@sisk.pl, pavel@suse.cz,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH x86] [15/16] Force __cpuinit on for CONFIG_PM without
	HOTPLUG_CPU
Message-ID: <20080110111514.GS25945@bingen.suse.de>
References: <20080103442.621670000@suse.de> <20080103154229.9723F14DDD@wotan.suse.de> <20080103181438.GA7141@does.not.exist> <200801031943.43828.ak@suse.de> <20080110095407.GB28740@does.not.exist> <20080110095857.GN25945@bingen.suse.de> <20080110101928.GC28740@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080110101928.GC28740@does.not.exist>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> But your patch does:
> 
> +config PM_CPUINIT
> +       bool
> +       depends on PM

That is because arch/x86/power/cpu.c where this happens is currently

obj-$(CONFIG_PM)                += cpu.o

If it was changed to CONFIG_something else then yes that dependency
should be changed too.

-Andi
