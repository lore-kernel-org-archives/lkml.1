Return-Path: <linux-kernel-owner+w=401wt.eu-S1761806AbZD3Jch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761806AbZD3Jch (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 05:32:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751706AbZD3Jc2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 05:32:28 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:59248 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306AbZD3Jc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 05:32:27 -0400
Date: Thu, 30 Apr 2009 09:33:48 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jack Stone <jwjstone@fastmail.fm>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: Arm and allyesconfig, allnoconfig, allmodconfig and randconfig
Message-ID: <20090430083348.GA4313@n2100.arm.linux.org.uk>
References: <1241080135.32735.1313058447@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241080135.32735.1313058447@webmail.messagingengine.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 30, 2009 at 10:28:55AM +0200, Jack Stone wrote:
> Hi All,
> 
> I've been trying to compile the Arm port of the kernel and noticed that
> allyesconfig etc. and randconfig don't seem to compile on Arm - they all
> end up with build errors (mostly about missing preprocessor defines eg
> __LINUX_ARM_ARCH__).

all*config are basically not supported on ARM.  (There are some, eg,
allmodconfig in conjunction with some defconfigs that might compile
but its very hit and miss.)

> Is this a known problem and if so can it be documented somewhere?

Patches welcome.
