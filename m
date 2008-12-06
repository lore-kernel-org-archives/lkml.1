Return-Path: <linux-kernel-owner+w=401wt.eu-S1756993AbYLFBKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756993AbYLFBKW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 20:10:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754680AbYLFBKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 20:10:09 -0500
Received: from main.gmane.org ([80.91.229.2]:41327 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754584AbYLFBKI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 20:10:08 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: mechanism to syncronise device access from user and kernel
Date: Fri, 05 Dec 2008 19:08:39 -0600
Message-ID: <4939D097.5030305@shaw.ca>
References: <377462.57009.qm@web30107.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: s0106000c41bb86e1.ss.shawcable.net
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
In-Reply-To: <377462.57009.qm@web30107.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Parav Pandit wrote:
> Hi,
> 
> I have a device whose registers are accessed by driver as well as user space application via mmap() area.
> 
> How to synchronize the access (avoid race condition) between user space driver and kernel mode driver, in single CPU and multi-CPU systems?

This doesn't seem like the best idea in the first place.. certainly not 
if unprivileged processes can get access to the registers, as there's no 
way to require them to follow the synchronization process. Generally a 
given set of registers should be driven by a kernel driver or a 
userspace process, not both.

