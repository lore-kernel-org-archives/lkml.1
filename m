Return-Path: <linux-kernel-owner+w=401wt.eu-S1761264AbZBMS7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761264AbZBMS7Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 13:59:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751531AbZBMS7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 13:59:13 -0500
Received: from smtprelay04.ispgateway.de ([80.67.18.16]:50199 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbZBMS7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 13:59:12 -0500
References: <cone.1234471033.988571.5384.1000@mentalhome> <20090213134024.GA26549@srcf.ucam.org>
Message-ID: <cone.1234551556.57236.4642.1000@onepiie>
X-Mailer: http://www.courier-mta.org/cone/
From: Peter Feuerer <peter@piie.net>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Acer Aspire One fan control
Date: Fri, 13 Feb 2009 19:59:16 +0100
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
X-Df-Sender: 404094
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett writes:

> That depends on how you're doing it. Is the code available somewhere? 

Just cleaned up the code and released it on my homepage, you can download 
it from: http://piie.net/files/acerhdf_kmod-0.2.tar.gz

> If 
> these io ports are also used by the firmware then you'll need to find 
> ACPI methods to call to perform the fan control. 

I get the temperature by calling ec_read(0x58) and can read/write the state 
of the fan by ec_write to / ec_read from 0x55. Actually I don't know if 
those embedded controller registers are used by the firmware. How can I find 
it out?

> If there aren't any 
> then it's not safe to have a driver to do this.

I think there should not be a problem when calling ec_write and ec_read 
from my kernel module, as those functions are atomic. Or am I wrong?

--peter
