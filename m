Return-Path: <linux-kernel-owner+w=401wt.eu-S1762793AbXGLTHY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762793AbXGLTHY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 15:07:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754744AbXGLTHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 15:07:11 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:27042 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755041AbXGLTHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 15:07:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=nbrce0zTs6SprubU1iQR1QiHjRqrmNiRCGE1lri0Uw2Ya1AaPfUcGAGmk5bfqOIgb6HAYMEK5iJrdfzfS8gDvhSY3Dg8qByh2NFPCihytC1//ZdLEpMBuxmohC9btaVWe9Z99UY0rZ/lVHnbMnSaMzc5T0xcbDupOI4j58TnFKM=
Message-ID: <a781481a0707121207o3497edbye9f89c9f2589f3e5@mail.gmail.com>
Date: Fri, 13 Jul 2007 00:37:07 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Zhang, Rui" <rui.zhang@intel.com>
Subject: Re: [PATCH][ACPI][BUTTON] remove procfs-interface
Cc: Henne <henne@nachtwindheim.de>, "Arjan van de Ven" <arjan@infradead.org>,
       "Brown, Len" <len.brown@intel.com>, linux-acpi@vger.kernel.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <823A93EED437D048963A3697DB0E35DE7314AB@pdsmsx414.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4695F726.7030203@nachtwindheim.de>
	 <823A93EED437D048963A3697DB0E35DE7314AB@pdsmsx414.ccr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/12/07, Zhang, Rui <rui.zhang@intel.com> wrote:
> Well, the ACPI sysfs conversion is not finished yet
> [...]
> I'm not sure if the button sysfs I/F is already finished.
> We'd better make a double check. :)

Ok, this sounds reasonable.

> and some user space tools still use the ACPI procfs.

But this does *not*, IMHO. It quite defeats the whole concept of
feature-removal-schedule.txt. I think that file exists precisely
because we cannot gratuitously break userspace interfaces just
like that, but when something gets put up there with a removal date
that is a good one year in the future, and userspace tools _still_
continue to use it ... then, I suspect something's seriously wrong.

Either the feature-removal-schedule.txt file has become something
that users don't even bother checking, or else, they _know_ that
even if they don't bother keeping up with the pace in kernel-land,
that interface still won't go away (because they're still using it!).
In both the above cases, it appears that file itself has become
irrelevant and a "feature" that could be "removed" ... :-)

> The schedule of removing ACPI procfs I/F will be changed to Jan 08.
> I'm about to send a patch to update it.

Satyam
