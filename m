Return-Path: <linux-kernel-owner+w=401wt.eu-S2992913AbXCIDLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992913AbXCIDLg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 22:11:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030844AbXCIDLg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 22:11:36 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:39773 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030859AbXCIDLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 22:11:36 -0500
Subject: Re: Any faster and more efficient way to repeatedly access /proc/*
From: Matthew Helsley <matthltc@us.ibm.com>
To: mchu@mirapoint.com
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070308165507.AMI36767@dougfood.mirapoint.com>
References: <20070308165507.AMI36767@dougfood.mirapoint.com>
Content-Type: text/plain
Date: Thu, 08 Mar 2007 19:11:32 -0800
Message-Id: <1173409893.18226.21.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-08 at 16:55 -0800, mchu@mirapoint.com wrote:
> Hi,
> 
> Is there a faster way to access "/proc/*" other than open it as a file and reading/parsing contents? e.g. fopen("/proc/stat", "r");
> 
> In BSD, there is the kvm method of access, which is relatively fast (light weight)
> 
> In Linux, if I have a daemon that keeps track of these statistics, it's a hell way to manage.
> 
> Imagine, having to probe the stat of each process?

Have you looked at Task Stats (CONFIG_TASKSTATS)?

Cheers,
	-Matt Helsley

