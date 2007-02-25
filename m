Return-Path: <linux-kernel-owner+w=401wt.eu-S964875AbXBYMy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964875AbXBYMy0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 07:54:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964878AbXBYMy0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 07:54:26 -0500
Received: from il.qumranet.com ([82.166.9.18]:37850 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964875AbXBYMyZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 07:54:25 -0500
Message-ID: <45E186FE.2000909@qumranet.com>
Date: Sun, 25 Feb 2007 14:54:22 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: kvm-devel <kvm-devel@lists.sourceforge.net>
CC: linux-kernel <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 0/4] KVM: Dirty page logging (aka live migration) fixes
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This small patchset plugs a few holes in the kvm dirty page logging 
implementation.  With these fixes (which really want to be in Linux 
2.6.21), one can migrate a running virtual machine from one host to 
another.  The virtual machine continues executing while its memory image 
is transferred, so there is only a minimal pause in service.

The patchset is also available as part of the kvm git tree; see 
http://kvm.qumranet.com/kvmwiki/Code.

-- 
error compiling committee.c: too many arguments to function

