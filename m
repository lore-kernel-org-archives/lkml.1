Return-Path: <linux-kernel-owner+w=401wt.eu-S1753606AbZA0BMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753606AbZA0BMh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 20:12:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752724AbZA0BM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 20:12:29 -0500
Received: from gw.goop.org ([64.81.55.164]:48662 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752572AbZA0BM2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 20:12:28 -0500
Message-ID: <497E5F76.10301@goop.org>
Date: Mon, 26 Jan 2009 17:12:22 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Brian Gerst <brgerst@gmail.com>, Tejun Heo <htejun@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: unified percpu stuff
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm really pleased to see the unified percpu stuff in the kernel, but 
unfortunately its breaking Xen at the moment. 

It looks like this is just a matter of initializing %gs properly in 
xen_start_kernel.  Is there any problem with me doing a load_gs_base(0) 
somewhere early in xen_start_kernel (arch/x86/xen/enlighten.c)?  Is the 
initial percpu are and offset for cpu0 all set up?  Do I need to make it 
#ifdef CONFIG_SMP?

Do I need to do anything for 32-bit? (I haven't tested that yet.)

Thanks,
    J


