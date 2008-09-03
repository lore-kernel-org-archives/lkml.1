Return-Path: <linux-kernel-owner+w=401wt.eu-S1755529AbYICFaT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529AbYICFaT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 01:30:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751993AbYICFaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 01:30:06 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:62807 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751985AbYICFaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 01:30:06 -0400
Date: Wed, 3 Sep 2008 06:28:54 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
cc: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [patch 1/2] x2apic: fix reserved APIC register accesses in
 print_local_APIC()
In-Reply-To: <20080902234759.554038000@linux-os.sc.intel.com>
Message-ID: <Pine.LNX.4.55.0809030625520.23174@cliff.in.clinika.pl>
References: <20080902234759.554038000@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Sep 2008, Suresh Siddha wrote:

> APIC_RRR is a reserved register for integrated APIC's.

 NAK this change -- the Remote Read register is officially supported up to 
the Pentium integrated APIC and to the best of my knowledge it works with 
the P6 APIC as well.  Any APIC using the serial inter-APIC bus should 
support it.

  Maciej
