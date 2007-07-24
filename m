Return-Path: <linux-kernel-owner+w=401wt.eu-S1759657AbXGXPk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759657AbXGXPk1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 11:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751856AbXGXPkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 11:40:17 -0400
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:5564 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970AbXGXPkP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 11:40:15 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAGu6pUarR7O6/2dsb2JhbAA
X-IronPort-AV: i="4.16,574,1175497200"; 
   d="scan'208"; a="506456564:sNHT89193196"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: Question about core file generation
Date: Tue, 24 Jul 2007 08:39:07 -0700
Message-ID: <FA6FB5FA4DA6BF4386D129273B2E3EC3024B80E8@xmb-sjc-214.amer.cisco.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Question about core file generation
Thread-Index: AcfOCMYXAD0raV0PTU694Tbh4ak2nA==
From: "Ravinandan Arakali \(rarakali\)" <rarakali@cisco.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 24 Jul 2007 15:40:04.0942 (UTC) FILETIME=[E7EC1EE0:01C7CE08]
Authentication-Results: sj-dkim-2; header.From=rarakali@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
When a process dumps core, the do_coredump() initiates the core
file generation. Is this operation synchronous(does the kernel
wait for core to be completely written to disk) ?
Basically, if I have the parent process waiting for exit of
child which dumped core, can the parent access the core immediately
on receipt of "child exit" message ? Is it possible that the
core is still in the process of being written ? If so, what's
the event the parent needs to wait for to be assured of a complete
core.

Thanks,
Ravi
