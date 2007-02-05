Return-Path: <linux-kernel-owner+w=401wt.eu-S932978AbXBET3u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932978AbXBET3u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 14:29:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933419AbXBET3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 14:29:49 -0500
Received: from outbound-cpk.frontbridge.com ([207.46.163.16]:57270 "EHLO
	outbound2-cpk-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933400AbXBET3s convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 14:29:48 -0500
X-BigFish: VP
X-Server-Uuid: 519AC16A-9632-469E-B354-112C592D09E8
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH 2/2] x86_64 irq: Handle irqs pending in IRR during
 irq migration.
Date: Mon, 5 Feb 2007 11:29:35 -0800
Message-ID: <5986589C150B2F49A46483AC44C7BCA4907414@ssvlexmb2.amd.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2/2] x86_64 irq: Handle irqs pending in IRR during
 irq migration.
Thread-Index: AcdHfb+7dQR6ye8nRSCfLvnBEwo/fQB3QoGw
From: "Lu, Yinghai" <yinghai.lu@amd.com>
To: "Andi Kleen" <ak@suse.de>, "Eric W. Biederman" <ebiederm@xmission.com>
cc: "Andrew Morton" <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       "Luigi Genoni" <luigi.genoni@pirelli.com>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Natalie Protasevich" <protasnb@gmail.com>
X-OriginalArrivalTime: 05 Feb 2007 19:29:37.0025 (UTC)
 FILETIME=[F8E97710:01C7495B]
X-WSS-ID: 69D95A2A0T06140014-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric,

How about let apic_hangle_pending_vector take the irq too?
I wonder if there any chance that you have two IRQ_MOVE_PENDING? 


BYW, Andi, Do you want to try "reuse vector when do the irq-balance
between CPUS"?

If So, I will update the patch that you dropped some months ago.

YH


