Return-Path: <linux-kernel-owner+w=401wt.eu-S1755900AbXJNDgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900AbXJNDgS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 23:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751403AbXJNDgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 23:36:09 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48400 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857AbXJNDgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 23:36:08 -0400
Date: Sun, 14 Oct 2007 04:35:49 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: gregkh@suse.de, David Brownell <dbrownell@users.sourceforge.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       Michael Buesch <mb@bu3sch.de>, linux-kernel@vger.kernel.org
Subject: Re: [bug] usb build failure, latest -git
Message-ID: <20071014033549.GQ8181@ftp.linux.org.uk>
References: <20071014032948.GA25760@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071014032948.GA25760@elte.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 14, 2007 at 05:29:48AM +0200, Ingo Molnar wrote:
> 
> FYI, the attached config fails to build on most recent -git with:
> 
>  In file included from drivers/usb/host/ohci-hcd.c:1038:
>  drivers/usb/host/ohci-ssb.c:120: error: 'ohci_bus_suspend' undeclared here (not in a function)
>  drivers/usb/host/ohci-ssb.c:121: error: 'ohci_bus_resume' undeclared here (not in a function)
>  make[3]: *** [drivers/usb/host/ohci-hcd.o] Error 1

Subject: [PATCH] ohci-ssb with !CONFIG_PM
