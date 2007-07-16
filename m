Return-Path: <linux-kernel-owner+w=401wt.eu-S1758220AbXGPHrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758220AbXGPHrj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 03:47:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753946AbXGPHrc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 03:47:32 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:61735 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873AbXGPHrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 03:47:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=pgCtQHNqCv55HH/11Rsm0P/kVJrX5pusghMd8N681KBbaAamf3lhtZiG68tVqGHhAwuzbWan87yo9NofQcRLNCWTkmvZ6o7VluesbebUOeNDNqpyn4W8dExN1lzKKbso31P+jB1RJafke8bIlCZNc7PK515qoEfBf81h6+UEdMY=
Message-ID: <a781481a0707160047i59b45797y491e9b303d2d8909@mail.gmail.com>
Date: Mon, 16 Jul 2007 13:17:27 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Stefan Seyfried" <seife@suse.de>
Subject: Re: [PATCH][BUTTON] remove procfs-interface
Cc: "Zhang, Rui" <rui.zhang@intel.com>, Henne <henne@nachtwindheim.de>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Brown, Len" <len.brown@intel.com>, linux-acpi@vger.kernel.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070716073533.GA23083@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4695F726.7030203@nachtwindheim.de>
	 <823A93EED437D048963A3697DB0E35DE7314AB@pdsmsx414.ccr.corp.intel.com>
	 <a781481a0707121207o3497edbye9f89c9f2589f3e5@mail.gmail.com>
	 <20070716073533.GA23083@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/16/07, Stefan Seyfried <seife@suse.de> wrote:

> Holy sh*t. There is not even a functional replacement ready, but still
> everybody wants to remove /proc/acpi. (Maybe the replacement started
> to work recently, i have not looked into this area for the last months.
> This does not change my pint, though).
> This is not going to work.
> IMNSHO, we need the new interface available and usable for quite some time
> (i'd say for over one year), and then we can start to phase out the old
> interface.
> Starting with removing /proc/acpi is not the correct ordering of actions.

Heh, you're 3 days late to the party, but yeah, Zhang's corrected me/
pointed this out (the functionality in /proc/acpi not yet in the sysfs I/F
being used by said userspace tools) already. I guess I had originally
misunderstood the "some user space tools still use the ACPI procfs" bit.

Satyam
