Return-Path: <linux-kernel-owner+w=401wt.eu-S932101AbXFEDl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932101AbXFEDl1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 23:41:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757523AbXFEDlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 23:41:20 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:56543 "EHLO
	pd3mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755729AbXFEDlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 23:41:19 -0400
Date: Mon, 04 Jun 2007 21:40:50 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Another missing RAM on x86_64
In-reply-to: <fa.tF0YmfAYyv6X2INP3hwTgQ2Z2Pw@ifi.uio.no>
To: Reinaldo de Carvalho <reinaldow@gmail.com>
Cc: linux-kernel@vger.kernel.org
Message-id: <4664DB42.2050401@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.tF0YmfAYyv6X2INP3hwTgQ2Z2Pw@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Reinaldo de Carvalho wrote:
> 1024MB dont detected on Notebook HP 2125 with kernel 2.6.21.3
> 

BIOS-provided physical RAM map:
  BIOS-e820: 0000000000000000 - 000000000009dc00 (usable)
  BIOS-e820: 000000000009dc00 - 00000000000a0000 (reserved)
  BIOS-e820: 00000000000d2000 - 0000000000100000 (reserved)
  BIOS-e820: 0000000000100000 - 000000003bf10000 (usable)
  BIOS-e820: 000000003bf10000 - 000000003bf19000 (ACPI data)
  BIOS-e820: 000000003bf19000 - 000000003bf80000 (ACPI NVS)
  BIOS-e820: 000000003bf80000 - 0000000040000000 (reserved)
  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
  BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)

This shows that memory from 0 to 631K and 1MB to 959MB are usable. Does 
this laptop have integrated graphics that could be using the rest?

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

