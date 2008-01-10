Return-Path: <linux-kernel-owner+w=401wt.eu-S1757547AbYAJSmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757547AbYAJSmR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 13:42:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755530AbYAJSl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 13:41:59 -0500
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:19966 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754313AbYAJSl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 13:41:58 -0500
Message-ID: <478666F4.50405@hp.com>
Date: Thu, 10 Jan 2008 10:41:56 -0800
From: Rick Jones <rick.jones2@hp.com>
User-Agent: Mozilla/5.0 (X11; U; HP-UX 9000/785; en-US; rv:1.7.13) Gecko/20060601
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Chris Friesen <cfriesen@nortel.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: questions on NAPI processing latency and dropped network packets
References: <478654C3.60806@nortel.com>
In-Reply-To: <478654C3.60806@nortel.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 1) Interrupts are being processed on both cpus:
> 
> root@base0-0-0-13-0-11-1:/root> cat /proc/interrupts
>            CPU0       CPU1
>  30:    1703756    4530785  U3-MPIC Level     eth0

IIRC none of the e1000 driven cards are multi-queue, so while the above 
shows that interrupts from eth0 have been processed on both CPUs at 
various points in the past, it doesn't necessarily mean that they are 
being processed on both CPUs at the same time right?

rick jones
