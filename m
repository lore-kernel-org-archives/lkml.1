Return-Path: <linux-kernel-owner+w=401wt.eu-S933158AbYBHAuH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933158AbYBHAuH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 19:50:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754006AbYBHAtz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 19:49:55 -0500
Received: from phoenix.slamd64.com ([217.10.145.2]:41248 "EHLO
	phoenix.slamd64.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484AbYBHAtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 19:49:53 -0500
X-Greylist: delayed 1227 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Feb 2008 19:49:53 EST
From: Carlos Corbacho <carlos@strangeworlds.co.uk>
To: "Ray Lee" <ray-lk@madrabbit.org>
Subject: Re: ACPI_WMI: worst config description of all times
Date: Fri, 8 Feb 2008 00:27:53 +0000
User-Agent: KMail/1.9.7
Cc: "Pavel Machek" <pavel@ucw.cz>, "Len Brown" <lenb@kernel.org>,
       "kernel list" <linux-kernel@vger.kernel.org>,
       "Linux-pm mailing list" <linux-pm@lists.osdl.org>,
       linux-acpi@vger.kernel.org
References: <20080207214715.GA15211@elf.ucw.cz> <200802072351.32521.carlos@strangeworlds.co.uk> <2c0942db0802071612r1b32f996jc26ac3792b8c31fc@mail.gmail.com>
In-Reply-To: <2c0942db0802071612r1b32f996jc26ac3792b8c31fc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802080027.54576.carlos@strangeworlds.co.uk>
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (phoenix.slamd64.com [217.10.145.2]); Fri, 08 Feb 2008 00:27:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 08 February 2008 00:12:24 Ray Lee wrote:
> While I'm not trying to set you up for a firing squad, if you can show
> that the only use this driver has is as underlying support for Acer/HP
> xyz drivers, 

Certainly at the moment, this is the only real use it has (and the only reason 
I spent any time working on a generic ACPI-WMI driver - probably one of the 
reasons Kconfig is somewhat neglected - ACPI-WMI is a means to an end for me 
(getting my laptop properly supported by another driver on top of it), not 
the end itself).

Although, given most of the other laptop drivers in drivers/misc use 'select' 
for various things, I don't see the harm here - unless anyone else has a 
great objection to acer-wmi and tc1100-wmi having 'select ACPI_WMI'?

-Carlos
-- 
E-Mail: carlos@strangeworlds.co.uk
Web: strangeworlds.co.uk
GPG Key ID: 0x23EE722D
