Return-Path: <linux-kernel-owner+w=401wt.eu-S1755416AbYFYIoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416AbYFYIoe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 04:44:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751657AbYFYIo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 04:44:26 -0400
Received: from mx0.towertech.it ([213.215.222.73]:60662 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751085AbYFYIoZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 04:44:25 -0400
Date: Wed, 25 Jun 2008 10:44:16 +0200
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: rtc-linux@googlegroups.com
Cc: huacai.chen@intel.com, <linux-acpi@vger.kernel.org>,
       <linux-pm@lists.linux-foundation.org>, <lenb@kernel.org>,
       <p_gortmaker@yahoo.com>, <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org
Subject: Re: [PATCH] RTC: Fix CMOS time error after writing /proc/acpi/alarm
Message-ID: <20080625104416.67af4680@i1501.lan.towertech.it>
In-Reply-To: <42DFA526FC41B1429CE7279EF83C6BDC014E42D5@pdsmsx415.ccr.corp.intel.com>
References: <42DFA526FC41B1429CE7279EF83C6BDC014E42D5@pdsmsx415.ccr.corp.intel.com>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jun 2008 18:52:21 +0800
"Chen, Huacai" <huacai.chen@intel.com> wrote:

> From: Huacai Chen <huacai.chen@intel.com>
> 
> When writing /proc/acpi/alarm in adjust mode, e.g. 
> 	echo "+0000-00-00 00:00:15" >/proc/acpi/alarm 
> The "century" field should be read and added to "year" field before
> writing, otherwise the CMOS time will go back to 2000 years ago, e.g.
> 	# cat /proc/acpi/alarm
> 	0008-06-21 11:38:46 
> Then the system time may be reset to the date of manufacture after
> rebooting. This patch fixed this issue.
> 
> Signed-off-by: Huacai Chen <huacai.chen@intel.com>
> Acked-by: Pavel Machek <pavel@suse.cz>

 Acked-by: Alessandro Zummo <a.zummo@towertech.it>

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

