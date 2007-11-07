Return-Path: <linux-kernel-owner+w=401wt.eu-S1758417AbXKGN3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758417AbXKGN3q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 08:29:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755464AbXKGN3j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 08:29:39 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:39434 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754959AbXKGN3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 08:29:38 -0500
From: Akio Takebe <takebe_akio@jp.fujitsu.com>
To: Glauber de Oliveira Costa <gcosta@redhat.com>
Cc: linux-kernel@vger.kernel.org, jeremy@goop.org, hollisb@us.ibm.com,
       kvm-devel@lists.sourceforge.net, avi@qumranet.com,
       Akio Takebe <takebe_akio@jp.fujitsu.com>
Subject: Re: [kvm-devel] include files for kvmclock
Date: Wed, 07 Nov 2007 22:27:46 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Mailer: HidemaruMail 4.60 (WinNT,501)
In-Reply-To: <4731BAB2.9040004@redhat.com>
References: <11943875362987-git-send-email-gcosta@redhat.com> <11943875433821-git-send-email-gcosta@redhat.com> <1DC8211684B62Btakebe_akio@jp.fujitsu.com> <4731BAB2.9040004@redhat.com>
Message-Id: <1FC82141FC3CCFtakebe_akio@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 

>> Why does kvm_hv_clock need page_align?
>Each vcpu will register a page on its own. In the guest side, it will be
>an array of pages. So, we make it page sized.
>
>> And also the kvm_hv_clock is alloced with kvm_vcpu,
>There's no requirements on the host part at all. So it doesn't really
>matter. In the next version, I may make it even a simple pointer.
>
>> so the align is not enough, isn't it?
>> I thik __atribute__((__aligne__(PAGE_SIZE)))) is better than it.
>It deals with the start of the structure, but not with its size. See the
>guest part: Where it matters, I do use it.
Oh, I confused the guest/host part, but I could understand it.
Thank you for your explanation.

Best Regards,

Akio Takebe

