Return-Path: <linux-kernel-owner+w=401wt.eu-S934377AbXEOLuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934377AbXEOLuV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 07:50:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755887AbXEOLuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 07:50:11 -0400
Received: from outbound-cpk.frontbridge.com ([207.46.163.16]:51178 "EHLO
	outbound1-cpk-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754809AbXEOLuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 07:50:09 -0400
X-BigFish: VP
X-Server-Uuid: 8C3DB987-180B-4465-9446-45C15473FD3E
From: "Peter Oruba" <peter.oruba@amd.com>
Organization: AMD
To: gregkh@suse.de, cramerj@intel.com, john.ronciak@intel.com,
       jesse.brandeburg@intel.com, jeffrey.t.kirsher@intel.com,
       auke-jan.h.kok@intel.com, rolandd@cisco.com, halr@voltaire.com,
       linux-driver@qlogic.com
Subject: [PATCH 0/2] PCI-X/PCI-Express read control interfaces
Date: Tue, 15 May 2007 13:50:27 +0200
User-Agent: KMail/1.9.6
cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Stephen Hemminger" <shemminger@linux-foundation.org>
MIME-Version: 1.0
Message-ID: <200705151350.28330.peter.oruba@amd.com>
X-OriginalArrivalTime: 15 May 2007 11:49:52.0001 (UTC)
 FILETIME=[25DA1710:01C796E7]
X-WSS-ID: 6A5741E920G2343777-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set introduces a PCI-X / PCI-Express read byte count control 
interface. Instead of letting every driver to directly read/write to PCI 
config space for that, an interface is provided. The interface functions then 
can be used for quirks since some PCI bridges require that read byte count 
values are set by the BIOS and left unchanged by device drivers.

Patch 1/2: PCI subsystem
Patch 2/2: affected drivers

Both patches are based on work by Stephen Hemminger, please see
http://lkml.org/lkml/2006/12/8/222

Regards,
Peter Oruba

-- 
AMD Saxony Limited Liability Company & Co. KG
Operating System Research Center
Wilschdorfer Landstr. 101, 01109 Dresden, Germany
Register Court Dresden: HRA 4896
General Partner authorized to represent:
AMD Saxony LLC (Wilmington, Delaware, US)
General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy


