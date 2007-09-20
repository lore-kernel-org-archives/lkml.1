Return-Path: <linux-kernel-owner+w=401wt.eu-S1756141AbXITMrH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141AbXITMrH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 08:47:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753093AbXITMq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 08:46:56 -0400
Received: from il.qumranet.com ([82.166.9.18]:55732 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752935AbXITMqz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 08:46:55 -0400
Message-ID: <46F26BAA.3040800@qumranet.com>
Date: Thu, 20 Sep 2007 14:46:34 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Jesse Barnes <jesse.barnes@intel.com>, Howard Chu <hyc@symas.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: MTRR initialization
References: <46EAB7DA.10507@symas.com> <200709191452.57505.jesse.barnes@intel.com> <p73d4wdal00.fsf@bingen.suse.de> <46F26208.309@qumranet.com> <20070920121013.GH18707@one.firstfloor.org>
In-Reply-To: <20070920121013.GH18707@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> Is there any reason not to set the MTRRs to define the entire memory as 
>> write back, and use PAT exclusively for setting cacheability?
>>     
>
> That risks breaking SMM or BIOS code.
>
>   


Yes.  Too bad.

-- 
error compiling committee.c: too many arguments to function

