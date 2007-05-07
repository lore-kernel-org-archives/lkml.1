Return-Path: <linux-kernel-owner+w=401wt.eu-S934238AbXEGOb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934238AbXEGOb2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 10:31:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934202AbXEGOb1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 10:31:27 -0400
Received: from iriserv.iradimed.com ([72.242.190.170]:38196 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933912AbXEGOb0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 10:31:26 -0400
Message-ID: <463F3847.1000300@cfl.rr.com>
Date: Mon, 07 May 2007 10:31:35 -0400
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: "Cabot, Mason B" <mason.b.cabot@intel.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Ext3 vs NTFS performance
References: <B326D0531AF1BA48B4C1E9EBA239A0500343FD11@scsmsx412.amr.corp.intel.com>
In-Reply-To: <B326D0531AF1BA48B4C1E9EBA239A0500343FD11@scsmsx412.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 May 2007 14:31:35.0040 (UTC) FILETIME=[6A025800:01C790B4]
X-TM-AS-Product-Ver: SMEX-7.2.0.1122-3.6.1039-15162.000
X-TM-AS-Result: No--3.139600-5.000000-31
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cabot, Mason B wrote:
> Philip:
> 
> the best response I can offer is that we have traced the application's
> file system accesses and seen no such one-byte writes occuring at that
> level. They are generated somewhere below the application. Additionally,
> while we have observed iTunes on Windows issuing these one-byte writes,
> ethereal traces for iTunes on Mac OSX show no such behavior. Because of
> these observations I think it is reasonable to conclude that the Windows
> CIFS client is generating the one-byte writes.

Can you duplicate this behavior with a very simple test program, rather 
than iTunes?  Will something as simple as open() and write() with a 32 
KB buffer of random data in a loop cause this behavior?

