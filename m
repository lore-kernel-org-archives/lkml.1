Return-Path: <linux-kernel-owner+w=401wt.eu-S1758656AbZJGNgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758656AbZJGNgd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 09:36:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754065AbZJGNgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 09:36:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27214 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752898AbZJGNgb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 09:36:31 -0400
Message-ID: <4ACC992F.3060001@redhat.com>
Date: Wed, 07 Oct 2009 09:35:43 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       venkatesh.pallipadi@intel.com, greg@kroah.com, riel@redhat.com,
       steven@uplinklabs.net, ext-eero.nurkkala@nokia.com, tglx@linutronix.de
CC: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:timers/urgent] NOHZ: update idle state also when NOHZ is
 inactive
References: <1254907901.30157.93.camel@eenurkka-desktop> <tip-fdc6f192e7e1ae80565af23cc33dc88e3dcdf184@git.kernel.org>
In-Reply-To: <tip-fdc6f192e7e1ae80565af23cc33dc88e3dcdf184@git.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tip-bot for Eero Nurkkala wrote:
> Commit-ID:  fdc6f192e7e1ae80565af23cc33dc88e3dcdf184
> Gitweb:     http://git.kernel.org/tip/fdc6f192e7e1ae80565af23cc33dc88e3dcdf184
> Author:     Eero Nurkkala <ext-eero.nurkkala@nokia.com>
> AuthorDate: Wed, 7 Oct 2009 11:54:26 +0300
> Committer:  Thomas Gleixner <tglx@linutronix.de>
> CommitDate: Wed, 7 Oct 2009 13:05:05 +0200
> 
> NOHZ: update idle state also when NOHZ is inactive
> 
> Commit f2e21c9610991e95621a81407cdbab881226419b had unfortunate side
> effects with cpufreq governors on some systems.
> 
> If the system did not switch into NOHZ mode ts->inidle is not set when
> tick_nohz_stop_sched_tick() is called from the idle routine. Therefor
> all subsequent calls from irq_exit() to tick_nohz_stop_sched_tick()
> fail to call tick_nohz_start_idle(). This results in bogus idle
> accounting information which is passed to cpufreq governors.
> 
> Set the inidle flag unconditionally of the NOHZ active state to keep
> the idle time accounting correct in any case.

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
