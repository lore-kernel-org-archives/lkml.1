Return-Path: <linux-kernel-owner+w=401wt.eu-S933106AbYCGA3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933106AbYCGA3p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 19:29:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761103AbYCGA3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 19:29:32 -0500
Received: from mx1.mxtelecom.com ([87.86.212.101]:35396 "EHLO
	puma.mxtelecom.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760976AbYCGA3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 19:29:32 -0500
X-Greylist: delayed 1477 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Mar 2008 19:29:31 EST
Message-ID: <47D086A4.6090103@mxtelecom.com>
Date: Fri, 07 Mar 2008 00:04:52 +0000
From: Matthew Hodgson <matthew@mxtelecom.com>
Organization: MX Telecom Ltd
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Toggling preemption on a running kernel
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm trying to compare the performance of some networking code 
(throughput and latency when receiving various volumes of UDP streams) 
between a preemptible and non-preemptible 2.6.24 kernel, and was 
wondering if it is possible to temporarily disable preemption on a 
running preemptible kernel.  Is it just a matter of loading a module 
which calls preempt_enable() at load and preempt_disable() at unload - 
or is that too naive?  Is there an existing way of doing this?

thanks,

Matthew.


-- 
Matthew Hodgson <matthew@mxtelecom.com>
Media & Systems Project Manager
Tel: +44 (0) 845 666 7778
http://www.mxtelecom.com
