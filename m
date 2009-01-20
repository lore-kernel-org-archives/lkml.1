Return-Path: <linux-kernel-owner+w=401wt.eu-S1763105AbZATUL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763105AbZATUL3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 15:11:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762367AbZATUK7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 15:10:59 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:45628 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761300AbZATUK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 15:10:58 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <49762FC8.7000208@s5r6.in-berlin.de>
Date: Tue, 20 Jan 2009 21:10:48 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.19) Gecko/20090104 SeaMonkey/1.1.14
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linux-scsi@vger.kernel.org
Subject: swiotlb default size (64 MB) too small?
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

somebody reported frequent "Out of SW-IOMMU space" failures when copying
between a FireWire and a USB disk.  swiotlb=512M on the kernel command
line fixes it for him. https://bugzilla.redhat.com/show_bug.cgi?id=478567

Should the default be raised?
-- 
Stefan Richter
-=====-==--= ---= =-=--
http://arcgraph.de/sr/
