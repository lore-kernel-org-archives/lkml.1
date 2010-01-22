Return-Path: <linux-kernel-owner+w=401wt.eu-S1751860Ab0AVMGP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751860Ab0AVMGP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 07:06:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751214Ab0AVMGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 07:06:14 -0500
Received: from mga05.intel.com ([192.55.52.89]:26024 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751125Ab0AVMGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 07:06:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,323,1262592000"; 
   d="scan'208";a="533614945"
Date: Fri, 22 Jan 2010 11:40:37 +0000
From: Alan Cox <alan@linux.intel.com>
To: Kirill Smelkov <kirr@mns.spb.ru>
Cc: linux-kernel@vger.kernel.org, Kirill Smelkov <kirr@mns.spb.ru>,
       Jiri Slaby <jirislaby@gmail.com>, Peter Botha <peterb@goldcircle.co.za>,
       Denis Vlasenko <vda@ilport.com.ua>
Subject: Re: [RFC PATCH] mxser: make /dev/ttyMI<n> namespace contiguous
Message-ID: <20100122114037.06d073bf@linux.intel.com>
In-Reply-To: <1264161402-4669-1-git-send-email-kirr@mns.spb.ru>
References: <1264161402-4669-1-git-send-email-kirr@mns.spb.ru>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Maybe let's teach mxser to create continous /dev entries in the first
> place?

The existing mapping is ABI. Users do not expect their devices to
suddenly move around. If the driver hadn't been merged yet I'd not
object to the concept. However it is now years too late.

Remap it in userspace if you want, add udev rules for it if you like,
but the kernel mapping is set in stone.

Alan
