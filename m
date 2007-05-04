Return-Path: <linux-kernel-owner+w=401wt.eu-S1161828AbXEDS4E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161828AbXEDS4E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 14:56:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161891AbXEDS4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 14:56:04 -0400
Received: from iriserv.iradimed.com ([72.242.190.170]:41904 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161828AbXEDS4A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 14:56:00 -0400
Message-ID: <463B81D4.50401@cfl.rr.com>
Date: Fri, 04 May 2007 14:56:20 -0400
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: "Cabot, Mason B" <mason.b.cabot@intel.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Ext3 vs NTFS performance
References: <B326D0531AF1BA48B4C1E9EBA239A050033DB3C1@scsmsx412.amr.corp.intel.com>
In-Reply-To: <B326D0531AF1BA48B4C1E9EBA239A050033DB3C1@scsmsx412.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 May 2007 18:56:12.0895 (UTC) FILETIME=[E2B57EF0:01C78E7D]
X-TM-AS-Product-Ver: SMEX-7.2.0.1122-3.6.1039-15156.000
X-TM-AS-Result: No--5.593800-5.000000-31
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cabot, Mason B wrote:
> I've been testing the NAS performance of ext3/Openfiler 2.2 against
> NTFS/WinXP and have found that NTFS significantly outperforms ext3 for
> video workloads. The Windows CIFS client will attempt a poor-man's
> pre-allocation of the file on the server by sending 1-byte writes at
> 128K-byte strides, breaking block allocation on ext3 and leading to
> fragmentation and poor performance. This will happen for many
> applications (including iTunes) as the CIFS client issues these
> pre-allocates under the application layer.

This is rather hard to believe so I think some more information is in 
order.  Specifically, how do you know that it is the windows kernel that 
is issuing these writes and not the application?  Under what application 
access patterns does it do this?

This is just rather hard to believe seeing as how, iirc, the CIFS 
protocol has commands to extend the file size properly rather than with 
this hack, and unless it is asked to by the application, the cifs client 
should not be trying to extend files.

