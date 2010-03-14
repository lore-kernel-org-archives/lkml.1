Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752579Ab0CNG0q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 01:26:46 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:36400 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750766Ab0CNG0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 01:26:45 -0500
Date: Sun, 14 Mar 2010 07:26:37 +0100
From: Pavel Machek <pavel@ucw.cz>
To: 640E9920 <640e9920@gmail.com>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       dwalker@codeaurora.org, tiwai@suse.de, bruce.w.allan@intel.com,
       aili@codeaurora.org, khilman@deeprootsystems.com,
       mgross@linux.intel.com
Subject: Re: [PATCH] PM_QOS updates for 2.6.34-rc1
Message-ID: <20100314062637.GA12064@elf.ucw.cz>
References: <20100314003425.GA17812@mgross-acer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100314003425.GA17812@mgross-acer>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2010-03-13 16:34:25, 640E9920 wrote:
> The following patch series implements to following:
> 1) pm_qos now uses a handle based implementation.  No more string
> compares while walking lists.
> 2) renames the exports to using more accurate names.
> 3) updates kernel clients of pm_qos per this change
> 4) added ascii interface to pmqos recognizing strings formatted in 10
> charactor format "0x12345678"
> 5) added new pm_qos class, "system_bus_throughput"
> 
> I would like to see this series make it into 2.6.34 if its not too late. 

I believe it is... -rc1 is past us.

Also... the way the patches are structured... that will break bisect,
no?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
