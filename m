Return-Path: <linux-kernel-owner+w=401wt.eu-S1758284AbYFXQu4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758284AbYFXQu4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 12:50:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751615AbYFXQut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 12:50:49 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:26015 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072AbYFXQus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 12:50:48 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5324"; a="4183947"
Message-ID: <486125E5.7020209@qualcomm.com>
Date: Tue, 24 Jun 2008 09:50:45 -0700
From: Max Krasnyanskiy <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: "Daniel K." <dk@uw.no>, mingo@elte.hu,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Paul Jackson <pj@sgi.com>, Gregory Haskins <ghaskins@novell.com>
Subject: Re: RT-Scheduler/cgroups: Possible overuse of resources assigned
 via cpu.rt_period_us and cpu.rt_runtime_us
References: <485917CF.1010401@uw.no> <1213799836.16944.244.camel@twins>	 <486090DC.7010705@qualcomm.com> <1214301185.4351.8.camel@twins>
In-Reply-To: <1214301185.4351.8.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Mon, 2008-06-23 at 23:14 -0700, Max Krasnyansky wrote:
> 
>> That seems too complicated :). There is no need to mount them separately.
> 
> Mounting them independently gives you much greater flexibility.
> 
> You quickly run into overlapping cpu sets if you want multiple groups on
> the isolated part.

Sure, it is more flexible but for simple cases it's more confusing.

Max
