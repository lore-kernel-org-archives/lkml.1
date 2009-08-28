Return-Path: <linux-kernel-owner+w=401wt.eu-S1751783AbZH1FXK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751783AbZH1FXK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 01:23:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751663AbZH1FXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 01:23:10 -0400
Received: from mail-px0-f174.google.com ([209.85.216.174]:63189 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbZH1FXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 01:23:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:references:mime-version:content-type
         :content-disposition:in-reply-to:user-agent:message-id;
        b=DQaQwsm+V8ed6YOG9RxwG8abp9M8+e0FuY9c45oOodYHBUELFFMc50fTbRi6k4lN0B
         FUjRIqPTfP1c0+u2KrxfQhkdgJFudaixjVEIaHCb4L97Wu4+Idy4wZEN/Kq0wI9rVlxF
         lju855EvI0E7HSjLEqTRSrVtEFpl1ns7vBzck=
Date: Thu, 27 Aug 2009 22:22:57 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
       Pavel Machek <pavel@ucw.cz>, Alan Stern <stern@rowland.harvard.edu>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>, Zhang Rui <rui.zhang@intel.com>,
       Linux PCI <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 7 updated] PM: Add a switch for disabling/enabling
	asynchronous suspend/resume
References: <200908262217.19609.rjw@sisk.pl> <200908272119.47053.rjw@sisk.pl> <20090827203948.9CD25526EC9@mailhub.coreip.homeip.net> <200908280022.40522.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908280022.40522.rjw@sisk.pl>
User-Agent: Mutt/1.5.19 (2009-01-05)
Message-Id: <20090828055520.E561A526EC9@mailhub.coreip.homeip.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 28, 2009 at 12:22:40AM +0200, Rafael J. Wysocki wrote:
> +/* kernel/power/main.c */
> +extern int pm_async_enabled;
>  

Sorry, forgot about this in the first mail - why don't we make it a
bool?

-- 
Dmitry
