Return-Path: <linux-kernel-owner+w=401wt.eu-S1752131AbXLKJrv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131AbXLKJrv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 04:47:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750986AbXLKJrm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 04:47:42 -0500
Received: from il.qumranet.com ([82.166.9.18]:58225 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750829AbXLKJrl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 04:47:41 -0500
Message-ID: <475E5CBB.9080608@qumranet.com>
Date: Tue, 11 Dec 2007 11:47:39 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
CC: kvm-devel <kvm-devel@lists.sourceforge.net>
Subject: [RFC] Proposed new directory layout for kvm and virtualization
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KVM is due to receive support for multiple architectures (ppc, ia64, and 
s390, in addition to the existing x86), hopefully in time for the 2.6.25 
merge window.  It is awkward to place the new arch support in 
drivers/kvm/, so I'd like to propose the following new layout:

  virt/         top-level directory for hypervisors
  virt/kvm/     kvm common code
  virt/lguest/  the other hypervisor
  arch/*/kvm/   arch dependent kvm code
  include/linux/kvm.h       arch independent interface
  include/asm/kvm.h         arch dependent interface
  include/linux/kvm_para.h  arch independent guest interface
  include/asm/kvm_para.h    arch dependent guest interface

The include/ hierarchy is already in place; I'm including it for 
completeness.

Comments, alternative suggestions welcome.

[This was foreshadowed about a year ago in 
http://lkml.org/lkml/2006/11/28/32, where the conclusion of the thread 
was to wait a year before making this change.  Quite an accurate 
prediction.]

-- 
error compiling committee.c: too many arguments to function

