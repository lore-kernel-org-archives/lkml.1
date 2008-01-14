Return-Path: <linux-kernel-owner+w=401wt.eu-S1754287AbYANJEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287AbYANJEW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 04:04:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752842AbYANJEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 04:04:10 -0500
Received: from hs-out-0708.google.com ([64.233.178.251]:10912 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752761AbYANJEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 04:04:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=mEP/I/hhvodIpd9wyq0N0KP8HtiAc17wWnAm1m/MQPy4EPAocpIBgZavp/d/D0v9N1IUhhry0lIuPcGQJ6Qh3fSrJoRCT3sgwqd8iR2n9UewHqP3ZN3AMcEU+zFC41Jhw0HH1jQuFj/GPGzbf1dT/eGQq3utWydgnYa0CKuH400=
Message-ID: <a8e1da0801140104m2d8dceaayd8cf85466659bbf@mail.gmail.com>
Date: Mon, 14 Jan 2008 17:04:05 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: 2.6.24-rc7 lockdep warning when poweroff
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

When I "halt -p", lockdep warnings triggered as following (hand copy):

WARNING : at kernel/lockdep.c: 700 lookup_lock_class()

<snip>
lock_acquire
cleanup_workqueue_thread
workqueue_cpu_callback
notifier_call_chain
__raw_notifier_call_chain
raw_notifier_call_chain
__cpu_down
disable_nonboot_cpus
kernel_power_off
sys_reboot
<snip>

Regards
dave
