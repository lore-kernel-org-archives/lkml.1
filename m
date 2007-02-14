Return-Path: <linux-kernel-owner+w=401wt.eu-S932149AbXBNJG4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932149AbXBNJG4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 04:06:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932160AbXBNJG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 04:06:56 -0500
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:61082 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932149AbXBNJGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 04:06:54 -0500
Message-ID: <45D2CD14.4090708@in.ibm.com>
Date: Wed, 14 Feb 2007 14:19:24 +0530
From: Balbir Singh <balbir@in.ibm.com>
Reply-To: balbir@in.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.9 (X11/20070103)
MIME-Version: 1.0
To: menage@google.com
CC: akpm@osdl.org, pj@sgi.com, sekharan@us.ibm.com, dev@sw.ru, xemul@sw.ru,
       serue@us.ibm.com, vatsa@in.ibm.com, ebiederm@xmission.com,
       containers@lists.osdl.org, winget@google.com, rohitseth@google.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/7] containers (V7): Add generic multi-subsystem API
 to containers
References: <20070212081521.808338000@menage.corp.google.com> <20070212085104.485337000@menage.corp.google.com>
In-Reply-To: <20070212085104.485337000@menage.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

menage@google.com wrote:
> This patch removes all cpuset-specific knowlege from the container
> system, replacing it with a generic API that can be used by multiple
> subsystems. Cpusets is adapted to be a container subsystem.
> 
> Signed-off-by: Paul Menage <menage@google.com>
> 

Hi, Paul,

This patch fails to apply for me

balbir@balbir-laptop:~/ocbalbir/images/kernels/containers/linux-2.6.20$ 
pushpatch
patching file include/linux/container.h
patching file include/linux/cpuset.h
patching file kernel/container.c
patch: **** malformed patch at line 640: @@ -202,15 +418,18 @@ static 
DEFINE_MUTEX(callback_mutex);

multiuser_container does not apply

Is anybody else seeing this problem?

-- 
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
