Return-Path: <linux-kernel-owner+w=401wt.eu-S1758650AbYA2EW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758650AbYA2EW5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 23:22:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754562AbYA2EWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 23:22:48 -0500
Received: from one.firstfloor.org ([213.235.205.2]:57219 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754275AbYA2EWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 23:22:47 -0500
Date: Tue, 29 Jan 2008 05:56:59 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Andi Kleen <andi@firstfloor.org>,
       Joachim Deguara <joachim.deguara@amd.com>, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       Dean Roe <roe@cray.com>
Subject: Re: [PATCH] x86: add PCI IDs to k8topology_64.c
Message-ID: <20080129045659.GA31847@one.firstfloor.org>
References: <200801281211.28214.joachim.deguara@amd.com> <p73y7a970nd.fsf@bingen.suse.de> <200801282012.47190.yinghai.lu@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801282012.47190.yinghai.lu@sun.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> also there are some users are using LinuxBIOS or other firmware that doesn't have  or like ACPI support. but they still need numa.
> for them ACPI doesn't help.

We've had this discussion before. The right way even if you don't 
want to do full ACPI is to do just the minimal static boot tables
and a SRAT. These are quite simple tables and should be easy to set up.
SRAT is essentially just a two dimensional table with node distances.

-Andi
