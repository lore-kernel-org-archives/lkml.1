Return-Path: <linux-kernel-owner+w=401wt.eu-S1751388AbXCDCL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751388AbXCDCL0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 21:11:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750791AbXCDCL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 21:11:26 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:57074 "EHLO
	pd2mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbXCDCL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 21:11:26 -0500
Date: Sat, 03 Mar 2007 20:09:47 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: asm/atomic.h and user code
In-reply-to: <1172958807.453840.180700@30g2000cwc.googlegroups.com>
To: "remi.chateauneu@gmail.com" <remi.chateauneu@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Message-id: <45EA2A6B.9090404@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <1172958807.453840.180700@30g2000cwc.googlegroups.com>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

remi.chateauneu@gmail.com wrote:
> Is it me or it seems it is not possible anymore to use asm/atomic.h in
> non-kernel code ? Thanks.

The atomic functions, as with any internal kernel data structures, were 
never intended to be used in userspace. In particular, the atomic 
functions depend on config settings like CONFIG_SMP in order to actually 
be atomic, and that's not guaranteed in userspace.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

