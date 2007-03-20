Return-Path: <linux-kernel-owner+w=401wt.eu-S1751892AbXCTRsA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751892AbXCTRsA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 13:48:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751830AbXCTRsA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 13:48:00 -0400
Received: from sj-iport-1-in.cisco.com ([171.71.176.70]:46652 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbXCTRr7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 13:47:59 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: Multiple instances of program sharing same text segment ?
Date: Tue, 20 Mar 2007 10:47:46 -0700
Message-ID: <FA6FB5FA4DA6BF4386D129273B2E3EC30183A437@xmb-sjc-214.amer.cisco.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Multiple instances of program sharing same text segment ?
thread-index: AcdrF963xpiuyTw3RnuBs9xRp1o3rA==
From: "Ravinandan Arakali \(rarakali\)" <rarakali@cisco.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 20 Mar 2007 17:47:47.0418 (UTC) FILETIME=[DF10ABA0:01C76B17]
Authentication-Results: sj-dkim-4; header.From=rarakali@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
We have multiple instances of the same executable running on our system.
Do these instances share the text segment or are there multiple copies
of the text segment(one for each process) ? Note that I am not talking
about the shared libraries.
I note that do_exec calls do_mmap to map the executable file to memory.
But not sure what happens(w.r.t text sharing) when another instance of 
the program is invoked. BTW, this is 2.6.10.

Thanks,
Ravi
