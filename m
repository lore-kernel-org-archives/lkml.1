Return-Path: <linux-kernel-owner+w=401wt.eu-S1763650AbXLMRwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763650AbXLMRwT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 12:52:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755560AbXLMRwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 12:52:08 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:54175 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754298AbXLMRwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 12:52:06 -0500
Date: Thu, 13 Dec 2007 09:47:44 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jerome Marchand <jmarchan@redhat.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk
Subject: Re: [Patch 7/8] Enhanced partition statistics: procfs
Message-Id: <20071213094744.eaa0b232.randy.dunlap@oracle.com>
In-Reply-To: <47616DAD.5020305@redhat.com>
References: <47615B3C.6030404@redhat.com>
	<20071213090756.73de4e3e.randy.dunlap@oracle.com>
	<47616DAD.5020305@redhat.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Dec 2007 18:36:45 +0100 Jerome Marchand wrote:

> Randy Dunlap wrote:
> > 
> > The format of the /proc file is not changed except to add data
> > at the end of each line.  Is that correct?
> > 
> 
> No. The line concerning partitions will display different data. The new format match the current format
> concerning disks.
> 
> Current partition format:
> major minor name reads_issued sectors_read writes_issued sectors_written
> 
> New partition format (current disk format):
> major minor name reads_issued reads_merged sector_read ms_reading writes_completed writes_merged sectors_written ms_writing I/Os_running ms_I/O weighted_ms_I/O


I would have expected the /proc file contents to represent a user
interface that we shouldn't change, other than by adding to the end
of each line.


---
~Randy
