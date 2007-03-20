Return-Path: <linux-kernel-owner+w=401wt.eu-S1750928AbXCTSWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750928AbXCTSWy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 14:22:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752601AbXCTSWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 14:22:54 -0400
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:46536 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbXCTSWw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 14:22:52 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Multiple instances of program sharing same text segment ?
Date: Tue, 20 Mar 2007 11:22:45 -0700
Message-ID: <FA6FB5FA4DA6BF4386D129273B2E3EC30183A439@xmb-sjc-214.amer.cisco.com>
In-Reply-To: <460023F1.8060102@goop.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Multiple instances of program sharing same text segment ?
thread-index: AcdrG2rvk7YNbP7BSdaGNItpYDVdwgAATEmg
References: <FA6FB5FA4DA6BF4386D129273B2E3EC30183A437@xmb-sjc-214.amer.cisco.com> <460023F1.8060102@goop.org>
From: "Ravinandan Arakali \(rarakali\)" <rarakali@cisco.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 20 Mar 2007 18:22:45.0989 (UTC) FILETIME=[C1E93150:01C76B1C]
Authentication-Results: sj-dkim-2; header.From=rarakali@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Jeremy.

Ravi 

-----Original Message-----
From: Jeremy Fitzhardinge [mailto:jeremy@goop.org] 
Sent: Tuesday, March 20, 2007 11:12 AM
To: Ravinandan Arakali (rarakali)
Cc: Linux Kernel
Subject: Re: Multiple instances of program sharing same text segment ?

Ravinandan Arakali (rarakali) wrote:
> I note that do_exec calls do_mmap to map the executable file to
memory.
> But not sure what happens(w.r.t text sharing) when another instance of

> the program is invoked. BTW, this is 2.6.10.

Yes, they will be shared.  As far as the rest of the kernel is
concerned, an mmap is an mmap is an mmap, and the pages will be shared.

    J
