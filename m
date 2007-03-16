Return-Path: <linux-kernel-owner+w=401wt.eu-S1753014AbXCPHbb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753014AbXCPHbb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 03:31:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753036AbXCPHbb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 03:31:31 -0400
Received: from 207.47.60.147.static.nextweb.net ([207.47.60.147]:31823 "EHLO
	rpc.xensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010AbXCPHba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 03:31:30 -0400
Subject: Re: [PATCH 1/1] Allow i386 crash kernels to handle x86_64 dumps
From: Ian Campbell <Ian.Campbell@XenSource.com>
To: vgoyal@in.ibm.com
Cc: Horms <horms@verge.net.au>, hbabu@us.ibm.com, fastboot@lists.osdl.org,
       linux-kernel@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>
In-Reply-To: <20070316024239.GB10515@in.ibm.com>
References: <1173891609.8591.41.camel@localhost.localdomain>
	 <20070315014635.GC28396@verge.net.au> <20070315045536.GA6766@in.ibm.com>
	 <20070315050754.GB22329@verge.net.au> <20070315054726.GC6766@in.ibm.com>
	 <1173961378.8591.63.camel@localhost.localdomain>
	 <20070315132616.GH6766@in.ibm.com> <20070315234807.GB10861@verge.net.au>
	 <20070316024239.GB10515@in.ibm.com>
Content-Type: text/plain
Date: Fri, 16 Mar 2007 07:31:26 +0000
Message-Id: <1174030286.28658.39.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Mar 2007 07:31:30.0112 (UTC) FILETIME=[1D388C00:01C7679D]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-16 at 08:12 +0530, Vivek Goyal wrote:
> I did not investigate deeper but I got a basic question. How will kexec
> know that underlying 32bit machine supports 64bit extensions or not?

It looks like /proc/cpuinfo flags contains "lm" (which is long mode,
right?) even if the machine is running 32 bit mode.

Ian.

