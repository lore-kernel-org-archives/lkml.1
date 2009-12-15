Return-Path: <linux-kernel-owner+w=401wt.eu-S1755878AbZLOElg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878AbZLOElg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 23:41:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753624AbZLOElg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 23:41:36 -0500
Received: from mail.digidescorp.com ([66.244.163.200]:57726 "EHLO
	digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181AbZLOElf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 23:41:35 -0500
X-Spam-Processed: digidescorp.com, Mon, 14 Dec 2009 22:41:35 -0600
X-Authenticated-Sender: steve@digidescorp.com
X-MDRemoteIP: 99.144.226.227
X-Return-Path: prvs=1600970eab=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Subject: RE: [microblaze-uclinux] [PATCH v2] microblaze: nommu: Don't
 clobber R11 on syscalls
From: "Steven J. Magnani" <steve@digidescorp.com>
Reply-To: steve@digidescorp.com
To: microblaze-uclinux@itee.uq.edu.au
Cc: linux-kernel@vger.kernel.org, monstr@monstr.eu
In-Reply-To: <005801ca7d0f$deaef5b0$9c0ce110$@com>
References: <1260829458-7503-1-git-send-email-steve@digidescorp.com>
	 <005801ca7d0f$deaef5b0$9c0ce110$@com>
Content-Type: text/plain
Organization: Digital Design Corporation
Date: Mon, 14 Dec 2009 22:41:28 -0600
Message-Id: <1260852089.3541.5.camel@iscandar.digidescorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-12-14 at 14:50 -0800, Jim Van Vorst wrote:
> Isn't R11 a temporary?  If it doesn't need to be preserved across function
> calls, why can't it be clobbered during a syscall?

Because the Microblaze syscall macros don't include r11 in the clobber
list. I suppose an alternative solution would just change the userspace
macros and not the kernel, even though there is a bug in the kernel. 

Michal, is the Microblaze ABI considered "locked down" now, or is a
kernel solution still permitted?

------------------------------------------------------------------------
 Steven J. Magnani               "I claim this network for MARS!
 www.digidescorp.com              Earthling, return my space modulator!"

 #include <standard.disclaimer>



