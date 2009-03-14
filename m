Return-Path: <linux-kernel-owner+w=401wt.eu-S1752767AbZCNIXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767AbZCNIXk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 04:23:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751456AbZCNIXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 04:23:25 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47424 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751251AbZCNIXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 04:23:24 -0400
Message-ID: <49BB6969.4040608@redhat.com>
Date: Sat, 14 Mar 2009 04:23:05 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Yasunori Goto <y-goto@jp.fujitsu.com>
CC: clemens@ladisch.de, Linux Kernel ML <linux-kernel@vger.kernel.org>,
       robert.picco@hp.com, venkatesh.pallipadi@intel.com, vojtech@suse.cz,
       mingo@redhat.com
Subject: Re: [Patch] Fix the possibility of insane return value of hpet_calibrate()
 against SMI.
References: <20090313134846.24B6.E1E9C6FF@jp.fujitsu.com>
In-Reply-To: <20090313134846.24B6.E1E9C6FF@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yasunori Goto wrote:

> hpet_calibrate() has a possibility of miss-calibration due to SMI.
> If SMI interrupts in the while loop of calibration, then return value
> will be big. This changes it tries 5 times and get minimum value as
> correct value.
> 
> Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
