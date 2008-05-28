Return-Path: <linux-kernel-owner+w=401wt.eu-S1759352AbYE1Ax7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759352AbYE1Ax7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 20:53:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757272AbYE1Axv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 20:53:51 -0400
Received: from pythia.bakeyournoodle.com ([203.82.209.197]:42381 "EHLO
	pythia.bakeyournoodle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755040AbYE1Axv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 20:53:51 -0400
Date: Wed, 28 May 2008 10:53:47 +1000
To: Meelis Roos <mroos@linux.ee>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org
Subject: Re: PPC PReP link failure - copy_page, empty_zero_page
Message-ID: <20080528005346.GK20457@bakeyournoodle.com>
References: <Pine.SOC.4.64.0805272022260.869@math.ut.ee>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.SOC.4.64.0805272022260.869@math.ut.ee>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: tony@bakeyournoodle.com (Tony Breeds)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2008 at 08:25:43PM +0300, Meelis Roos wrote:
> While compiling the current kernel on prep ppc:
> 
>   MODPOST 703 modules
> ERROR: "copy_page" [fs/fuse/fuse.ko] undefined!
> ERROR: "empty_zero_page" [fs/ext4/ext4dev.ko] undefined!

Try that patch at: http://patchwork.ozlabs.org/linuxppc/patch?id=18710

Fixes it for me.

Yours Tony

  linux.conf.au    http://www.marchsouth.org/
  Jan 19 - 24 2009 The Australian Linux Technical Conference!

