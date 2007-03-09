Return-Path: <linux-kernel-owner+w=401wt.eu-S2992842AbXCIA7b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992842AbXCIA7b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 19:59:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992849AbXCIA7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 19:59:31 -0500
Received: from dougfood.mirapoint.com ([63.107.133.21]:59182 "EHLO
	dougfood.mirapoint.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992842AbXCIA7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 19:59:30 -0500
X-Greylist: delayed 363 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Mar 2007 19:59:30 EST
From: <mchu@mirapoint.com>
Subject: Any faster and more efficient way to repeatedly
 access /proc/*
To: linux-kernel@vger.kernel.org
X-Mailer: Mirapoint Webmail Direct 4.0.0.1-L
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20070308165507.AMI36767@dougfood.mirapoint.com>
Date: Thu,  8 Mar 2007 16:55:07 -0800 (PST)
X-Junkmail-Whitelist: YES (by domain whitelist at dougfood.mirapoint.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Is there a faster way to access "/proc/*" other than open it as a file and reading/parsing contents? e.g. fopen("/proc/stat", "r");

In BSD, there is the kvm method of access, which is relatively fast (light weight)

In Linux, if I have a daemon that keeps track of these statistics, it's a hell way to manage.

Imagine, having to probe the stat of each process?

Thanks,
Michael
