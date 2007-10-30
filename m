Return-Path: <linux-kernel-owner+w=401wt.eu-S1756917AbXJ3VLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756917AbXJ3VLo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 17:11:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753531AbXJ3VLf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 17:11:35 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42155 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753657AbXJ3VLe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 17:11:34 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: 2.6.24: (ACPI AC adapter) sending {proc,netlink,kobject}_event from -> resume method?
Date: Tue, 30 Oct 2007 22:28:24 +0100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       Alexey Starikovskiy <astarikovskiy@suse.de>
References: <200710302233.31791.arvidjaar@mail.ru>
In-Reply-To: <200710302233.31791.arvidjaar@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710302228.25650.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 30 October 2007 20:33, Andrey Borzenkov wrote:
> Is it valid to send events from within ->resume device method?

It is or at least it should be.  The GPEs are supposed to be fully functional
at this point.

> If not, what is the proper way to notify user space about hardware changes
> during suspension?  
> Specifically it seems that new sysfs ACPI power supply interface sometimes 
> missing plugged in AC cord during suspend. I suspect that no event is 
> generated for this; I am not sure whether ACPI is required to generate such 
> events at all in this case.
> 
> I'll need some time to get reproducible case so I do not categorize this yet 
> as regression.

Is the "[2.6.24-rc1 regression] AC adapter state does not change after resume"
message a follow-up to this one?

Rafael
