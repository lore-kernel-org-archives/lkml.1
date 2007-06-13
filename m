Return-Path: <linux-kernel-owner+w=401wt.eu-S1758227AbXFMXLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758227AbXFMXLU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 19:11:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755180AbXFMXLL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 19:11:11 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:14210 "EHLO
	pd3mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754177AbXFMXLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 19:11:10 -0400
Date: Wed, 13 Jun 2007 17:11:02 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [Processor] Hi-Temperature showed in trip points
In-reply-to: <fa.OUIh82xbyasQTxsKpcOOV8N3QM0@ifi.uio.no>
To: "Renato S. Yamane" <renatoyamane@mandic.com.br>
Cc: linux-kernel@vger.kernel.org
Message-id: <46707986.6050706@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 8BIT
References: <fa.OUIh82xbyasQTxsKpcOOV8N3QM0@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Renato S. Yamane wrote:
> Hi,
> I have a laptop Toshiba M45-S355 (with Intel Pentium M Processor 750 - 
> 1.86GHz) and trip points show me hi-temperature (that is unsupported by 
> this processor):
> 
> $ uname -a
> Linux mandachuva 2.6.21.1 #1 PREEMPT Sun May 20 22:28:53 BRT 2007 i686 
> GNU/Linux
> 
> $ cat /proc/acpi/thermal_zone/TZCL/trip_points
> critical (S5):           105 C
> 
> MAX temperature suported by this processor is 100°C (I see this in Intel 
> specifications), so I think that is not very good idea allow 
> temperatures higher than 100°C.

That trip point comes from the BIOS.. likely complain to Toshiba, if 
anyone. Likely the CPU itself will start throttling or shut down well 
before that temperature is reached.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

