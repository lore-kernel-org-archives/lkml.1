Return-Path: <linux-kernel-owner+w=401wt.eu-S1763445AbYCEXWH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763445AbYCEXWH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 18:22:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754182AbYCEXVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 18:21:49 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51862 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757261AbYCEXVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 18:21:48 -0500
Date: Wed, 5 Mar 2008 15:21:24 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: oakad@exemail.com.au
Cc: linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: Re: MemoryStick driver updates
Message-Id: <20080305152124.5381de30.akpm@linux-foundation.org>
In-Reply-To: <1204646548-27466-1-git-send-email-oakad@exemail.com.au>
References: <1204646548-27466-1-git-send-email-oakad@exemail.com.au>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  5 Mar 2008 03:02:17 +1100
oakad@exemail.com.au wrote:

> 
> This patch series consists of the following:
> 1. Important (data corruption) fix to the tifm memorystick backend
> 2. Initial commit of JMicron memorystick backend
> 3. Some additional minor updates, including much better bitfield defines

Thanks, I queued these for 2.6.25.

Greg has a memstick-convert-struct-class_device-to-struct-device.patch at
http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/gregkh-01-driver-core
which still applies and compiles on top of these changes, but I didn't of
course check whether it works at runtime.

It would be good if you were to review and runtime-test his patch, if you
have not yet done so.  Testing next -mm would be a suitable way of doing
that (it wasn't in 2.6.25-rc3-mm1).


