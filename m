Return-Path: <linux-kernel-owner+w=401wt.eu-S1758140AbZCAUOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758140AbZCAUOT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 15:14:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753852AbZCAUOE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 15:14:04 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48239 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757646AbZCAUOD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 15:14:03 -0500
Message-ID: <49AAEC79.3000808@redhat.com>
Date: Sun, 01 Mar 2009 15:13:45 -0500
From: Brian Maly <bmaly@redhat.com>
User-Agent: Thunderbird 1.5.0.2 (X11/20060501)
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Huang Ying <ying.huang@intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix e820 end address with EFI
References: <49A965AD.10701@redhat.com>	 <86802c440902282014he17bb6an1f59872ef30db0c5@mail.gmail.com> <86802c440902282142p14f623b8td8a88600ff2a6bbe@mail.gmail.com>
In-Reply-To: <86802c440902282142p14f623b8td8a88600ff2a6bbe@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was able verify the kernel that does not boot on the MacBook (vanilla 
2.6.29-rc4) does call efi_ioremap() which bails out early returning 
NULL. So no remapping happens in this case.  I have no idea if 
efi_ioremap ever does succeed in mapping any ranges though being I have 
no video or console this early in the boot and have to rely on triple 
faulting as a means of debugging.

Brian
