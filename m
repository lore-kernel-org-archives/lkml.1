Return-Path: <linux-kernel-owner+w=401wt.eu-S965532AbXA3OwK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965532AbXA3OwK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 09:52:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965543AbXA3OwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 09:52:10 -0500
Received: from il.qumranet.com ([62.219.232.206]:47490 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965532AbXA3OwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 09:52:09 -0500
Message-ID: <45BF5B96.1070007@qumranet.com>
Date: Tue, 30 Jan 2007 16:52:06 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: kvm-devel <kvm-devel@lists.sourceforge.net>
CC: linux-kernel <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 0/5] KVM: suspend/resume support
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The following patchset allows a host with running virtual machines to be 
suspended and, on at least a subset of the machines tested, resumed.  
Note that this is orthogonal to suspending and resuming an individual 
guest to a file.

A side effect of implementing suspend/resume is that cpu hotplug is now 
supported.  This should please the owners of big iron.

Andrew, please queue for 2.6.21.

-- 
error compiling committee.c: too many arguments to function

