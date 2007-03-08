Return-Path: <linux-kernel-owner+w=401wt.eu-S933082AbXCHTLs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933082AbXCHTLs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 14:11:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933079AbXCHTLs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 14:11:48 -0500
Received: from mail.tnnet.fi ([217.112.240.26]:35642 "EHLO mail.tnnet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933083AbXCHTLr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 14:11:47 -0500
Message-ID: <45F05FEB.9AED3D31@users.sourceforge.net>
Date: Thu, 08 Mar 2007 21:11:39 +0200
From: Jari Ruusu <jariruusu@users.sourceforge.net>
To: Kandan Venkataraman <kven709@cse.unsw.EDU.AU>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] Loop device - Tracking page writes made to a loop 
 devicethrough mmap
References: <Pine.LNX.4.64.0703081342000.21734@williams.orchestra.cse.unsw.EDU.AU>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kandan Venkataraman wrote:
> All comments have been taken care of.

Your patch still does not do conversions of existing user space visible
'struct loop_info64' which is pretty much cast in stone. Blindly overwriting
larger structure over smaller user space buffer of existing userspace
binaries is the wrong way to do this.

There was a time when folks at least pretended that breaking user space ABI
was not tolerable.

-- 
Jari Ruusu  1024R/3A220F51 5B 4B F9 BB D3 3F 52 E9  DB 1D EB E3 24 0E A9 DD
