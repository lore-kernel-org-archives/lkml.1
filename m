Return-Path: <linux-kernel-owner+w=401wt.eu-S1764833AbYEVMcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764833AbYEVMcS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 08:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757682AbYEVMcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 08:32:08 -0400
Received: from web95101.mail.in2.yahoo.com ([203.104.18.153]:32042 "HELO
	web95101.mail.in2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755309AbYEVMcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 08:32:07 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=HtTuN0WPjF/Kn6WxbG8NOOnuZ8BMklDGXmvNs2rt9Qp10LLL+q+oFvqR487+ZWWNq2IpHNMxY+PJe8M4XbnmvNCI+Wqq2IXnmnihqBwjMC7fecS3vOa5XVJLEqT824M11ZSkoOqMihrshnso5Qll7KXJG+suZPJ4x/5kaKQ1A/s=;
X-YMail-OSG: Yr9qM98VM1lhHyhPl.n6F.VHbbHSje5FNi9do3NaXF4fCDQfcnDB_zhiiGXz4oUrwJIsUJspVNLfRfCpaAEqG11p5iCirYPCH_Qc2_c9DmYD6OmYS3h0u10.aA--
Date: Thu, 22 May 2008 13:32:01 +0100 (BST)
From: murtuja bharmal <murtuja_bharmal@yahoo.com>
Subject: CLONE_THREAD issue
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <914168.17218.qm@web95101.mail.in2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello All,

 I am testing one small module in 2.6.16 kernel, which
is intilizing one Tasklet funcion and creating one
kernel thread using kernel_thread() which is
responsible for Scheduling Tasklet, Inside the Tasklet
function I have just putted one printk statement.

I am calling Tasklet Intilization and kernel_thread
inside module init fucntion.

This is my kernel_thread function.
kernel_thread(thread_entry_point, 0,
CLONE_VM|CLONE_FS|CLONE_FILES|CLONE_SIGHAND|CLONE_THREAD)

Inside thread_entry_point I am scheduling Tasklet.

Problem is When I remove CLONE_THREAD form
kernel_thread function everything is working fine.
but with CLONE_THREAD, I am even not able to load the
module just after doing insmoe <module name> maching
get hang.

Looking for help.

Thanks,
Murtuja



      Explore your hobbies and interests. Go to http://in.promos.yahoo.com/groups/
