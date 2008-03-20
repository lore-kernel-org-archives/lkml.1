Return-Path: <linux-kernel-owner+w=401wt.eu-S1756313AbYCTO1A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756313AbYCTO1A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 10:27:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755415AbYCTO0u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 10:26:50 -0400
Received: from gw.goop.org ([64.81.55.164]:35395 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755364AbYCTO0t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 10:26:49 -0400
Message-ID: <47E27348.5090705@goop.org>
Date: Thu, 20 Mar 2008 07:23:04 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: "Dong, Eddie" <eddie.dong@intel.com>
CC: virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-ia64@vger.kernel.org,
       kvm-ia64-devel@lists.sourceforge.net,
       xen-ia64-devel@lists.xensource.com
Subject: Re: Xen common code across architecture
References: <12047411453864-git-send-email-yamahata@valinux.co.jp>	<12047411473158-git-send-email-yamahata@valinux.co.jp> <10EA09EFD8728347A513008B6B0DA77A02EF8C3A@pdsmsx411.ccr.corp.intel.com>
In-Reply-To: <10EA09EFD8728347A513008B6B0DA77A02EF8C3A@pdsmsx411.ccr.corp.intel.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dong, Eddie wrote:
> 	Current xen kernel codes are in arch/x86/xen, but xen dynamic
> irqchip (events.c) are common for other architectures such as IA64. We
> are in progress with enabling pv_ops for IA64 now and want to reuse same
> code, do we need to move the code to some place common? suggestions?

I'm fine with moving common stuff like that to drivers/xen/.

    J
