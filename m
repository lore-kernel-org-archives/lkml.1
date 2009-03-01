Return-Path: <linux-kernel-owner+w=401wt.eu-S1757304AbZCAURo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757304AbZCAURo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 15:17:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752918AbZCAURf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 15:17:35 -0500
Received: from hera.kernel.org ([140.211.167.34]:33708 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752416AbZCAURf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 15:17:35 -0500
Message-ID: <49AAED22.5010700@kernel.org>
Date: Sun, 01 Mar 2009 12:16:34 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Brian Maly <bmaly@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Huang Ying <ying.huang@intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix e820 end address with EFI
References: <49A965AD.10701@redhat.com>	 <86802c440902282014he17bb6an1f59872ef30db0c5@mail.gmail.com> <86802c440902282142p14f623b8td8a88600ff2a6bbe@mail.gmail.com> <49AAEC79.3000808@redhat.com>
In-Reply-To: <49AAEC79.3000808@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Brian Maly wrote:
> I was able verify the kernel that does not boot on the MacBook (vanilla
> 2.6.29-rc4) does call efi_ioremap() which bails out early returning
> NULL. So no remapping happens in this case.  I have no idea if
> efi_ioremap ever does succeed in mapping any ranges though being I have
> no video or console this early in the boot and have to rely on triple
> faulting as a means of debugging.

earlyprintk=vga should work at that point....

YH
