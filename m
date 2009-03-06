Return-Path: <linux-kernel-owner+w=401wt.eu-S1756035AbZCFWxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035AbZCFWxf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 17:53:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753551AbZCFWx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 17:53:26 -0500
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:46625 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753435AbZCFWx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 17:53:26 -0500
Date: Fri, 6 Mar 2009 22:53:12 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Darren Hart <dvhltc@us.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       "lkml, " <linux-kernel@vger.kernel.org>
Subject: Re: Dynamically determine if kernel includes CFS Scheduler
Message-ID: <20090306225312.GA25593@silver.sucs.org>
References: <49B18B2E.606@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49B18B2E.606@us.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 06, 2009 at 12:44:30PM -0800, Darren Hart wrote:
> I've received an internal request for a means to determine at run-time 
> if the CFS scheduler is included in the running kernel.  Looking through 
> the git commit log and the /proc/sys/kernel filesystem, I think I see 
> two approaches:

Sounds dangerous (you are dependent on scheduler beahviour) but if it
exists you could check /proc/config.gz (or the config file in the /boot
directory)...

-- 
Sitsofe | http://sucs.org/~sits/
