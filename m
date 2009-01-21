Return-Path: <linux-kernel-owner+w=401wt.eu-S1753580AbZAUUvE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580AbZAUUvE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 15:51:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752374AbZAUUuy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 15:50:54 -0500
Received: from charybdis-ext.suse.de ([195.135.221.2]:50423 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751975AbZAUUux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 15:50:53 -0500
Message-ID: <49778AAF.5000604@suse.de>
Date: Wed, 21 Jan 2009 23:50:55 +0300
From: Alexey Starikovskiy <astarikovskiy@suse.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Jacek Luczak <difrost.kernel@gmail.com>
CC: len.brown@intel.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [ACPI] GPE storm detected on FS Amilo Pro
References: <4977352B.1040303@gmail.com>
In-Reply-To: <4977352B.1040303@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jacek,

You did not receive "GPE storm detected" message in earlier kernel only because
there was no detection of it. You can check if you have one by enabling "#define DEBUG" 
at the beginning of the /drivers/acpi/ec.c and looking into dmesg. If there is no storm,
you should see ony 2-3 interrupt messages per single transaction. Storm detector fires 
up at 8 excess interrupts.

Regards,
Alex.


Jacek Luczak wrote:
> Hi All,
> 
> 
> I've got that ,,GPE storm detected'' issue on my Fujitsu Siemens Amilo Pro
> notebook.  I was using 2.6.25.20 (which was fine) for a long while and recently
> started testing some latest git versions starting from 2.6.29-rc2 where I've
> discovered that issue. So I've made some back kernels and it shows up from
> 2.6.26 kernel. Bisection between 2.6.25 and 2.6.26 shows that patch:

