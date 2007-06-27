Return-Path: <linux-kernel-owner+w=401wt.eu-S1759470AbXF0FH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759470AbXF0FH2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 01:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752135AbXF0FHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 01:07:18 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:41434 "EHLO
	pd3mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711AbXF0FHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 01:07:17 -0400
Date: Tue, 26 Jun 2007 23:06:55 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH] ata: Add the SW NCQ support to sata_nv for
 MCP51/MCP55/MCP61
In-reply-to: <fa.5TBvnXzjCgAIfcuKOLBWeXi+y5I@ifi.uio.no>
To: kuan luo <kuanluo@gmail.com>
Cc: linux-kernel@vger.kernel.org, jeff@garzik.org, akpm@linux-foundation.org,
       pchen@nvidia.com, kluo@nvidia.com
Message-id: <4681F06F.1050302@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.5TBvnXzjCgAIfcuKOLBWeXi+y5I@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

kuan luo wrote:
> Add the Software NCQ support to sata_nv.c for MCP51/MCP55/MCP61 SATA 
> controller.
> NCQ function is disable by default, you can enable it with 'swncq=1'
> 
> Signed-off-by: Kuan Luo <kluo@nvidia.com>
> Signed-off-by: Peer Chen <pchen@nvidia.com>
> 

Haven't reviewed in detail, but does look cleaner than the previous 
version. Some people reported seeing some unrecognized FIS, etc. errors 
with the previous version, have those been looked into/fixed?

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

