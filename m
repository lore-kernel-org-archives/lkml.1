Return-Path: <linux-kernel-owner+w=401wt.eu-S1756473AbZDVUHp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756473AbZDVUHp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 16:07:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754779AbZDVUHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 16:07:18 -0400
Received: from mail.tpi.com ([70.99.223.143]:4198 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754601AbZDVUHR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 16:07:17 -0400
Message-ID: <49EF78F2.7040203@tpi.com>
Date: Wed, 22 Apr 2009 14:07:14 -0600
From: Tim Gardner <timg@tpi.com>
Reply-To: timg@tpi.com
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: malattia@linux.it, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Sony laptop: Some Sony Vaia laptops do not enable wwan
 power by default.
References: <20090422185351.AB41AF88CE@sepang.rtg.net> <20090422195034.GA32375@srcf.ucam.org>
In-Reply-To: <20090422195034.GA32375@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett wrote:
> On Wed, Apr 22, 2009 at 12:53:51PM -0600, Tim Gardner wrote:
>> Mattia,
>>
>> Does this patch makes sense for just the Vaio? I've had positive feedback from
>> the tester in the bug report.
> 
> It'd make more sense to change the wwan power option to use rfkill. That 
> way it'll be powered up at appropriate times.
> 

The laptop model that doesn't power up wwan on cold boot contains a
"Sony Programmable IO Control Driver" ("VGN-" according to the DMI
info). It appears that only laptops with a "Sony Notebook Control
Driver" enjoy rfkill goodness. I don't know for sure if those models
fail to power up wwan when rfkill is disabled.

rtg
-- 
Tim Gardner timg@tpi.com www.tpi.com
OR 503-601-0234 x102 MT 406-443-5357
