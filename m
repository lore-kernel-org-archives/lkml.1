Return-Path: <linux-kernel-owner+w=401wt.eu-S1763539AbZE0Ndo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763539AbZE0Ndo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 09:33:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763525AbZE0Nd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 09:33:27 -0400
Received: from www.tglx.de ([62.245.132.106]:41960 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763487AbZE0NdZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 09:33:25 -0400
Date: Wed, 27 May 2009 15:33:03 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Rik van Riel <riel@redhat.com>
cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tero.kristo@nokia.com, ext-eero.nurkkala@nokia.com,
       venkatesh.pallipadi@intel.com
Subject: Re: [tip:timers/urgent] NOHZ: Properly feed cpufreq ondemand
 governor
In-Reply-To: <4A1D3EEC.3050106@redhat.com>
Message-ID: <alpine.LFD.2.00.0905271532250.3397@localhost.localdomain>
References: <12432346571351-git-send-email-ext-eero.nurkkala@nokia.com> <tip-cf1240033cc81216a18eec0ca71466f7fe4eeda8@git.kernel.org> <4A1D3EEC.3050106@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 May 2009, Rik van Riel wrote:
> Calling return without restoring the
> local_irq_save(flags) right above the
> line where you get the CPU number seems
> like a bad idea.

I should probably stay away from keyboard today. :(
