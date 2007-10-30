Return-Path: <linux-kernel-owner+w=401wt.eu-S1756896AbXJ3UhT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756896AbXJ3UhT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 16:37:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754062AbXJ3UhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 16:37:05 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:42111 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018AbXJ3UhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 16:37:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=cIQe0iLKUjPZbrbpN/Gem5M2tJ9qaiohmvvcsP6dpDnez17+VcgY5xLoluuMUQFPeVw8d+3UAuZz9ZoBp/b9jk9SWPdc8MdIveN8q/v9lciJ+vsiA0B7vUPV6GPFTTJp0Wj6ceFBnXu91PdE5kbEargW9K5D0mHjpkza6wi57dE=
Message-ID: <472795DF.6010000@gmail.com>
Date: Tue, 30 Oct 2007 23:36:47 +0300
From: Alexey Starikovskiy <aystarik@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Andrey Borzenkov <arvidjaar@mail.ru>
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [2.6.24-rc1 regression] AC adapter state does not change after
 resume
References: <200710302324.52822.arvidjaar@mail.ru>
In-Reply-To: <200710302324.52822.arvidjaar@mail.ru>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrey Borzenkov wrote:
> I suspect new ACPI AC adapter code but have to add some printk's to be sure.
> 
> To reproduce - plug in AC cord, suspend, unplug, resume - kpowersave and sysfs 
> still show AC adapter online. Or other way round.
> 
> -andrey
The only change to drivers/acpi/ac.c after .23 was d5b4a3d0efa36de31b86d5677dad6c36cb8735d7.
Don't see how it could lead to less messages from AC.

Regards,
Alex.
