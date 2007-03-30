Return-Path: <linux-kernel-owner+w=401wt.eu-S932234AbXC3Al4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932234AbXC3Al4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 20:41:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934195AbXC3Al4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 20:41:56 -0400
Received: from smtp.osdl.org ([65.172.181.24]:44476 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932234AbXC3Alz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 20:41:55 -0400
Date: Thu, 29 Mar 2007 17:41:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Simon Horman <horms@verge.net.au>
Cc: Vivek Goyal <vgoyal@in.ibm.com>, fastboot@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kdump/kexec: calculate note size at compile time
Message-Id: <20070329174145.0db7779f.akpm@linux-foundation.org>
In-Reply-To: <20070329033056.GD22141@verge.net.au>
References: <20070328061855.GA9576@verge.net.au>
	<20070328064353.GD4941@in.ibm.com>
	<20070328071315.GC29303@verge.net.au>
	<20070328080853.GE4941@in.ibm.com>
	<20070329033056.GD22141@verge.net.au>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Mar 2007 12:30:59 +0900
Simon Horman <horms@verge.net.au> wrote:

> [PATCH] kdump/kexec: calculate note size at compile time

i386 allmodconfig, gcc-4.1.0:

In file included from init/initramfs.c:508:
include/linux/kexec.h:148: error: variable-size type declared outside of any function
