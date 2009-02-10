Return-Path: <linux-kernel-owner+w=401wt.eu-S1754126AbZBJAy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126AbZBJAy0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 19:54:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751936AbZBJAyR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 19:54:17 -0500
Received: from mga02.intel.com ([134.134.136.20]:18354 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751549AbZBJAyQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 19:54:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,182,1233561600"; 
   d="scan'208";a="488656616"
Subject: Re: Oopses and ACPI problems (Linus 2.6.29-rc4)
From: yakui_zhao <yakui.zhao@intel.com>
To: Darren Salt <linux@youmustbejoking.demon.co.uk>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
In-Reply-To: <gemini.ket9w800w44dc0hvg.linux@youmustbejoking.demon.co.uk>
References: <gemini.ket9w800w44dc0hvg.linux@youmustbejoking.demon.co.uk>
Content-Type: text/plain; charset=utf-8
Organization: Intel Open Source Technology Center
Date: Tue, 10 Feb 2009 09:06:00 +0800
Message-Id: <1234227960.3706.67.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-10 at 02:26 +0800, Darren Salt wrote:
> I'm seeing various oopses with -rc4, where -rc3 is fine; config, dmesg
> (captured via netconsole) and decoded oops data attached ¹. The last few
> oopses were followed by a scrambled display and a hard lockup.
> 
> All oopses follow an otherwise successful suspend-to-RAM.
> 
> Also, I see that Fn-Fx don't seem to be reported via /proc/acpi/events any
> more, or at least I'm seeing no evidence of them via acpi_listen (and, not
> coincidentally, I can't adjust the volume etc. via eeepc-acpi-scripts).
> 
> The only other (significant) change is that I've installed X from Debian
> experimental, though -rc3 and 2.6.28.* seem fine with this. (Oh, and I can
> get UXA to cause OOM quite trivially... several Iceweasel tabs is enough.)
> 
>From the description it seems that this is a regression. 
Will you please use git-bisect to identify which commit causes the
regression?
   Thanks.
> 
> ¹ Yes, I decided not to include symbol names in the running kernel...
> 

