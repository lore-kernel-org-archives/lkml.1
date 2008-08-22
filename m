Return-Path: <linux-kernel-owner+w=401wt.eu-S1760579AbYHVMnx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760579AbYHVMnx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 08:43:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759090AbYHVMnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 08:43:17 -0400
Received: from mail.enyo.de ([212.9.189.167]:40585 "EHLO mail.enyo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755767AbYHVMnQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 08:43:16 -0400
X-Greylist: delayed 2670 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Aug 2008 08:43:16 EDT
From: Florian Weimer <fw@deneb.enyo.de>
To: linux-kernel@vger.kernel.org
Subject: Disabling hypervisor capability at boot
Date: Fri, 22 Aug 2008 13:58:44 +0200
Message-ID: <8763pt8dmz.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For various reasons, it might be desirable to disable hypervisor
capability during the system boot-up process.

It has been suggested to do this in user space.  While I think it's fine
to trigger it from user space (in the sense that an additional boot
parameter makes no difference), I'm not convinced that the actual code
to disable the hypervisor capability should reside in user space.  What
about architectures where this step can only performed from kernel mode?
