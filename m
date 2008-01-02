Return-Path: <linux-kernel-owner+w=401wt.eu-S1755032AbYABS56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755032AbYABS56 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 13:57:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752451AbYABS5u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 13:57:50 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:35796 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752568AbYABS5t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 13:57:49 -0500
Message-ID: <477BDEA5.8040701@garzik.org>
Date: Wed, 02 Jan 2008 13:57:41 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Allen Martin <AMartin@nvidia.com>
CC: Robert Hancock <hancockr@shaw.ca>, Tejun Heo <htejun@gmail.com>,
       Gabor Gombas <gombasg@sztaki.hu>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, Kuan Luo <kluo@nvidia.com>,
       Peer Chen <pchen@nvidia.com>
Subject: Re: sata_nv + ADMA + Samsung disk problem
References: <20070808120804.GB5257@boogie.lpds.sztaki.hu> <20080101164416.GA29574@boogie.lpds.sztaki.hu> <477B0429.7040909@gmail.com> <477B0CFD.1030603@shaw.ca> <F72FA20C31DD4F4C997B91C5B3690A09505577@hqemmail07.nvidia.com>
In-Reply-To: <F72FA20C31DD4F4C997B91C5B3690A09505577@hqemmail07.nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allen Martin wrote:
>> The question I had for NVIDIA regarding this that I never got 
>> answered 
>> was, is there any reason why we would need a delay when switching 
>> between NCQ and non-NCQ commands on ADMA, and if not, is 
>> there any known 
>> cause that could cause the controller to get into this seemingly 
>> locked-up state?
> 
> When switching from NCQ to non NCQ or vice versa you must make sure all
> outstanding commands are completed before issuing the new command.  The
> hardware doesn't do anything to prevent queued and non queued commands
> from going out on the wire at the same time which will certainly cause
> some drives to fail.

The software definitely provides that guarantee for all NCQ-capable 
controllers.

	Jeff



