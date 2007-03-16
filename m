Return-Path: <linux-kernel-owner+w=401wt.eu-S1751576AbXCPSbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751576AbXCPSbc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 14:31:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751613AbXCPSbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 14:31:32 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:51081 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576AbXCPSbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 14:31:31 -0400
Subject: Re: [PATCH] Add an offset in the cyc2ns computation to fix
	sched_clock jumps
From: Daniel Walker <dwalker@mvista.com>
To: Guillaume Chazarain <guichaz@gmail.com>
Cc: Andi Kleen <ak@suse.de>, john stultz <johnstul@us.ibm.com>,
       mathieu.desnoyers@polymtl.ca, linux-kernel@vger.kernel.org
In-Reply-To: <3d8471ca0703161114o7ad654car60c1a6b801401149@mail.gmail.com>
References: <3d8471ca0703161114o7ad654car60c1a6b801401149@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 16 Mar 2007 11:30:46 -0700
Message-Id: <1174069846.3101.113.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-16 at 19:14 +0100, Guillaume Chazarain wrote:
> Hello,
> 
> The scheduling problems I reported in the thread:
> http://lkml.org/lkml/2007/3/3/128
> are caused by the set_cyc2ns_scale() function called when the CPU speed changes.
> Changing the scale causes a warp in the value returned by sched_clock().
> 

Did you explain what the "werirdnes" was exactly? If not, could you?

Daniel

