Return-Path: <linux-kernel-owner+w=401wt.eu-S1752414AbZH0UE1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414AbZH0UE1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 16:04:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752378AbZH0UE0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 16:04:26 -0400
Received: from mail-pz0-f178.google.com ([209.85.222.178]:49882 "EHLO
	mail-pz0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358AbZH0UEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 16:04:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:references:mime-version:content-type
         :content-disposition:in-reply-to:user-agent:message-id;
        b=AsJOLFQyP7U5fjV31/CgwpW9K80KdiC2lQoQPcrjJ5rN+xzFJ/mKKwdMHprAjqLxwk
         WJTsH6OnnzoHSi86AF0rBwBOmmrk/tczgTM92v6hEaI7hiH/ylorUcMv64KnlFHGVLOQ
         +y/1p6PW1VGD6sWJr+O9MBeVHw2mrXxC2zquw=
Date: Thu, 27 Aug 2009 13:04:20 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
       Pavel Machek <pavel@ucw.cz>, Alan Stern <stern@rowland.harvard.edu>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>, Zhang Rui <rui.zhang@intel.com>,
       Linux PCI <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 8] PM: Allow user space to change the
	power.async_suspend flag of devices
References: <200908262217.19609.rjw@sisk.pl> <200908270025.34821.rjw@sisk.pl> <200908272117.52931.rjw@sisk.pl> <200908272120.56021.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908272120.56021.rjw@sisk.pl>
User-Agent: Mutt/1.5.19 (2009-01-05)
Message-Id: <20090827203634.372EC526EC9@mailhub.coreip.homeip.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

On Thu, Aug 27, 2009 at 09:20:55PM +0200, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Add sysfs attribute power/async for every device allowing the user
> space to access the device's power.async_suspend flag and modify it,
> if necessary.
> 

I don't think we should let users meddle with individual devices;
one global flag should be enough to work around "broken-at-the-moment"
issues.

-- 
Dmitry
