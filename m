Return-Path: <linux-kernel-owner+w=401wt.eu-S1755835AbYKQBk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835AbYKQBk3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 20:40:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754097AbYKQBkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 20:40:19 -0500
Received: from mga09.intel.com ([134.134.136.24]:5087 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753824AbYKQBkS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 20:40:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,615,1220252400"; 
   d="scan'208";a="360848940"
Subject: Re: [STABLE PATCH .26 .27] ACPI: avoid empty file name in sysfs
From: Zhang Rui <rui.zhang@intel.com>
To: Pavel Machek <pavel@suse.cz>
Cc: Len Brown <lenb@kernel.org>, "stable@kernel.org" <stable@kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20081115171725.GB1523@ucw.cz>
References: <alpine.LFD.2.00.0811130015100.3128@localhost.localdomain>
	 <20081115171725.GB1523@ucw.cz>
Content-Type: text/plain
Date: Mon, 17 Nov 2008 09:40:12 +0800
Message-Id: <1226886012.15014.231.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-11-16 at 01:17 +0800, Pavel Machek wrote:
> Hi!
> 
> > upstream 4feba70a2c1a1a0c96909f657f48b2e11e682370
> > 
> > Since commit bc45b1d39a925b56796bebf8a397a0491489d85c acpi tables are
> > allowed to have an empty signature and /sys/firmware/acpi/tables uses the
> > signature as filename.  Applications using naive recursion through /sys
> > loop forever.  A possible solution would be: (replacing the zero length
> > filename with the string "NULL")
> 
> What about using some string that is not a valid table name? Shorter
> than 4 characters? AFAICT,
> 'NULL' table could be added to acpi in future...?
> 
> What if *two* tales have empty signature?
there are "NULL1" and "NULL2" in this case.

thanks,
rui

