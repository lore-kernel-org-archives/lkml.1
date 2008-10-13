Return-Path: <linux-kernel-owner+w=401wt.eu-S1755412AbYJMBcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412AbYJMBcQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 21:32:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754343AbYJMBb7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 21:31:59 -0400
Received: from mga01.intel.com ([192.55.52.88]:37081 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754254AbYJMBb6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 21:31:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,399,1220252400"; 
   d="scan'208";a="390689595"
Subject: Re: acpi-test tree on eeepc: EC error message on second resume
From: Zhao Yakui <yakui.zhao@intel.com>
To: Alexey Starikovskiy <astarikovskiy@suse.de>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alexey Starikovskiy <aystarik@gmail.com>,
       linux acpi <linux-acpi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <48F24EAE.6020108@suse.de>
References: <48F0DB0C.7060201@tuffmail.co.uk>
	 <200810112140.16662.rjw@sisk.pl> <48F100CA.2050600@suse.de>
	 <200810112254.09094.rjw@sisk.pl> <48F1BFD0.7040004@tuffmail.co.uk>
	 <48F24EAE.6020108@suse.de>
Content-Type: text/plain
Date: Mon, 13 Oct 2008 13:56:36 +0800
Message-Id: <1223877396.4141.33.camel@yakui_zhao.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-10-12 at 23:23 +0400, Alexey Starikovskiy wrote:
> +static int ec_wait_ibf0(struct acpi_ec *ec)
> +{
> +       unsigned long delay = jiffies +
> msecs_to_jiffies(ACPI_EC_DELAY);
> +       while (time_before(jiffies, delay)) {
> +               if (wait_event_timeout(ec->wait, ec_check_ibf0(ec),
> +                                       msecs_to_jiffies(1)))
> +               return 0;
Please add the bogus timeout check.
best regards.
   Yakui
> +       }
> +       return -ETIME;
> +}
> + 

