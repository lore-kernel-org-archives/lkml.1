Return-Path: <linux-kernel-owner+w=401wt.eu-S1754552AbZDELBl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552AbZDELBl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 07:01:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751322AbZDELB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 07:01:28 -0400
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:26256 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751238AbZDELB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 07:01:28 -0400
X-Trace: 173649751/mk-filter-4.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.41.47.161/None/adrian@newgolddream.dyndns.info
X-SBRS: None
X-RemoteIP: 80.41.47.161
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-MUA: Evolution 2.24.3 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao0FANIr2ElQKS+h/2dsb2JhbACBUsgFhA8G
X-IronPort-AV: E=Sophos;i="4.39,325,1235952000"; 
   d="scan'208";a="173649751"
Subject: Re: CONFIG_FW_LOADER
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1238905089.19390.7.camel@violet>
References: <1238868348.6489.8.camel@localhost.localdomain>
	 <1238905089.19390.7.camel@violet>
Content-Type: text/plain
Date: Sun, 05 Apr 2009 12:01:15 +0100
Message-Id: <1238929275.6511.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-04-05 at 06:18 +0200, Marcel Holtmann wrote:
> Hi Adrian,
> 
> > Currently the help for this states: 
> > 
> > 
> > CONFIG_FW_LOADER:
> > This option is provided for the case where no in-kernel-tree modules
> > require userspace firmware loading support, but a module built outside
> > the kernel tree does.
> > 
> > 
> > Is it just me or is this somewhat misleading? Don't all modules that
> > load firmware from userspace require this?
> 
> all drivers that do use 'select FW_LOADER' and so they trigger building
> this module anyway. The config option is purely if you have a driver
> that is built outside the tree and wanna use request_firmware().
> 

OK. Guess the issue is that my module doesn't select this. I'll patch
that.

