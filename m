Return-Path: <linux-kernel-owner+w=401wt.eu-S1763993AbYJJVBn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763993AbYJJVBn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 17:01:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760191AbYJJVBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 17:01:34 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:34688 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760135AbYJJVBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 17:01:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=mLFifYcMcjo0XeC3cCbU6Gn7QVdrpo3l6wuHdzYA9OI9/VAbBLT8oJzZApdqsuJs/z
         fzyv/+cCqWpFshu/yjRMLG8BB8Pa7z2ztjxyMex0J1ZNilP7+gwBxPIEoJKyHANzb1tP
         QlcoXJZTt5B+k29WKeV/pYOyhxtNkXzk16QSM=
Message-ID: <f7848160810101401l250fa459pdbe00d57c51a326@mail.gmail.com>
Date: Fri, 10 Oct 2008 17:01:33 -0400
From: "Parag Warudkar" <parag.lkml@gmail.com>
To: "Alan Stern" <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] WARNING: at kernel/power/main.c:176 suspend_test_finish+0x70/0x80()
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "pm list" <linux-pm@lists.linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.0810101542320.2185-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200810102134.27112.rjw@sisk.pl>
	 <Pine.LNX.4.44L0.0810101542320.2185-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2008 at 3:44 PM, Alan Stern <stern@rowland.harvard.edu> wrote:

> Or even better, suspend with the USB drivers present, and with
> CONFIG_USB_DEBUG, CONFIG_PM_SLEEP, and CONFIG_PRINTK_TIME all enabled.
> The resulting detailed timing information should pinpoint the problem.

As of now it is reproducible without USB modules loaded. But any way
will try this over weekend.

Parag
