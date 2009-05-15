Return-Path: <linux-kernel-owner+w=401wt.eu-S1761298AbZEOKhN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761298AbZEOKhN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 06:37:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757757AbZEOKg6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 06:36:58 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:53261 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757329AbZEOKg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 06:36:58 -0400
X-Greylist: delayed 1805 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 May 2009 06:36:57 EDT
Date: Fri, 15 May 2009 10:50:32 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Wei Yongjun <yjwei@cn.fujitsu.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] devpts: change the default value of devpts mode to 0620
Message-ID: <20090515105032.167eeb66@lxorguk.ukuu.org.uk>
In-Reply-To: <4A0D2438.7020509@cn.fujitsu.com>
References: <4A0CFB90.3060109@cn.fujitsu.com>
	<4A0CFCD0.70605@cn.fujitsu.com>
	<4A0D2438.7020509@cn.fujitsu.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 May 2009 16:13:44 +0800
Wei Yongjun <yjwei@cn.fujitsu.com> wrote:

> The value of devpts mode is usually set to 620 in file
> /etc/fstab like this:
> 
> $grep devpts /etc/fstab
> devpts /dev/pts devpts gid=5,mode=620 0 0
> 
> But the default mode value of devpts is 0600. Why not
> set it to 0620? This patch change it 0620.

NAK

The default is effectively ABI so you are changing it for people using
the 0600 default and doing nothing at all useful for those with 0620
defaults in their mount tab (which btw is distro dependant policy)
