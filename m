Return-Path: <linux-kernel-owner+w=401wt.eu-S1422693AbXBHFBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422693AbXBHFBS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 00:01:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422713AbXBHFBS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 00:01:18 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:20861 "EHLO
	pd3mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422693AbXBHFBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 00:01:17 -0500
Date: Wed, 07 Feb 2007 22:56:45 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: PROBLEM: sata timeouts with intel 82801HB on amd64
In-reply-to: <fa.R4l8gBCDmrTiB/K/hEhS7a0vNoI@ifi.uio.no>
To: Paolo Ornati <ornati@fastwebnet.it>,
       linux-kernel <linux-kernel@vger.kernel.org>
Cc: Trevor Offner Caira <toc3@cornell.edu>
Message-id: <45CAAD8D.7030007@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.C/AbnQN5ZU4HbNob5u7LvtyVH3U@ifi.uio.no>
 <fa.R4l8gBCDmrTiB/K/hEhS7a0vNoI@ifi.uio.no>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paolo Ornati wrote:
> If mounting XFS with "nobarrier" fixes the problem it seems that more
> than one Seagate disk cannot handle the Cache Flush command while other
> commands are in fly...

It's not allowed to overlap NCQ (FPDMA read/write) commands with any 
other commands such as cache flushes. libata core guarantees that this 
doesn't happen by deferring such requests until the FPDMA commands are 
complete. (At least, it's supposed to..)

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

