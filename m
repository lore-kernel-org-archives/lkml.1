Return-Path: <linux-kernel-owner+w=401wt.eu-S1756012AbXKFHMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012AbXKFHMS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 02:12:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754719AbXKFHML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 02:12:11 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40650 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754712AbXKFHMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 02:12:10 -0500
Date: Mon, 5 Nov 2007 23:11:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, greg@kroah.com,
       Stephane Eranian <eranian@hpl.hp.com>
Subject: Re: [RFC] kobject and kset core changes and cleanups
Message-Id: <20071105231148.4f1bd0b1.akpm@linux-foundation.org>
In-Reply-To: <20071102235758.GA9803@kroah.com>
References: <20071102235758.GA9803@kroah.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Nov 2007 16:57:58 -0700 Greg KH <gregkh@suse.de> wrote:

> So, I go on vacation for a week or so and come back to an overflowing
> inbox.  Instead of trying to wade through all of that, I decide to
> finish up the work Kay and I had started on cleaning up the kset core
> code.

you killed perfmon.

perfmon/perfmon_sysfs.c: In function 'pfm_init_sysfs':
perfmon/perfmon_sysfs.c:411: error: 'kernel_subsys' undeclared (first use in this function)
perfmon/perfmon_sysfs.c:411: error: (Each undeclared identifier is reported only once
perfmon/perfmon_sysfs.c:411: error: for each function it appears in.)

I'll drop the perfmon tree and shall soldier on.  
