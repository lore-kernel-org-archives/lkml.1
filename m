Return-Path: <linux-kernel-owner+w=401wt.eu-S1764954AbXLMRib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764954AbXLMRib (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 12:38:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762384AbXLMRiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 12:38:22 -0500
Received: from mx1.redhat.com ([66.187.233.31]:55858 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761922AbXLMRiV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 12:38:21 -0500
Message-ID: <47616DAD.5020305@redhat.com>
Date: Thu, 13 Dec 2007 18:36:45 +0100
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070105)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: linux-kernel@vger.kernel.org, axboe@kernel.dk
Subject: Re: [Patch 7/8] Enhanced partition statistics: procfs
References: <47615B3C.6030404@redhat.com> <20071213090756.73de4e3e.randy.dunlap@oracle.com>
In-Reply-To: <20071213090756.73de4e3e.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> 
> The format of the /proc file is not changed except to add data
> at the end of each line.  Is that correct?
> 

No. The line concerning partitions will display different data. The new format match the current format
concerning disks.

Current partition format:
major minor name reads_issued sectors_read writes_issued sectors_written

New partition format (current disk format):
major minor name reads_issued reads_merged sector_read ms_reading writes_completed writes_merged sectors_written ms_writing I/Os_running ms_I/O weighted_ms_I/O

Jérôme
