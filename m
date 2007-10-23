Return-Path: <linux-kernel-owner+w=401wt.eu-S1752759AbXJWNff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759AbXJWNff (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 09:35:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751827AbXJWNf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 09:35:28 -0400
Received: from mga07.intel.com ([143.182.124.22]:13604 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751491AbXJWNf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 09:35:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,317,1188802800"; 
   d="scan'208";a="303956038"
Message-ID: <471DF8A9.1010605@linux.intel.com>
Date: Tue, 23 Oct 2007 09:35:37 -0400
From: Anas Nashif <nashif@linux.intel.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Maxim Levitsky <maximlevitsky@gmail.com>
CC: linux-kernel@vger.kernel.org, Marek Dabek <marek.dabek@intel.com>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] Intel Manageability Engine Interface driver
References: <471CDC5E.4010300@linux.intel.com> <200710230030.03705.maximlevitsky@gmail.com>
In-Reply-To: <200710230030.03705.maximlevitsky@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Maxim Levitsky wrote:
> 
> Will integrated sensors on DG965 motherboard be supported?
> They can be accessed only through the
> HECI interface, but the board has no AMT, and even if it had one, I don't 
> think AMT includes HW sensors.
> 
True, this is supported using QST.

> Will it be supported?

The MEI driver (HECI) is the first step toward supporting this in Linux. 
We are working on a QST release for Linux in the form of an SDK that can 
be used for example by lm_sensors to expose the sensors.

> I really need it (I have to reboot to bios each time to see the sensors, which is
> both inaccurate, and annoying)
> 

Yes, we know how annoying it is and we are working on it.

Anas

> 
> Best regards,
> 	Maxim Levitsky
