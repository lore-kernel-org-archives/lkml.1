Return-Path: <linux-kernel-owner+w=401wt.eu-S1756522AbYHEHMn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756522AbYHEHMn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 03:12:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760842AbYHEHIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 03:08:39 -0400
Received: from ti-out-0910.google.com ([209.85.142.184]:57040 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760828AbYHEHIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 03:08:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=waxRn0mrsZ6tfxk25sOJ4mdueyaQvZFgV46FT/CkKtDiFufgnqVxb+gkcdoXLHGKZf
         1PjZDWcAo4kOXTFGhPChvhLoCoQcWb6UDqZHveQWoe7Tx2nxjNGbJ5NFttt1uLAtB62N
         nQEdEodQfsmNomFvtxt26A6jVPbuldnp/LPZk=
Message-ID: <3666888f0808050008h38e11737k8e6cb9c4c85aa457@mail.gmail.com>
Date: Tue, 5 Aug 2008 17:08:35 +1000
From: "David Wilson" <mcs6502@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: What is the best way to identify a new x86 processor that does not implement the CPUID instruction?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I recently bought a Norhtec MicroClient JrSX which uses the Vortex86sx
System on Chip processor (see http://vortex86sx.com/ for more
details). This is identified as a Cyrix 486SLC by the Linux kernel due
to the lack of a CPUID instruction. While this may be seen as a
cosmetic defect, if the kernel can identify the processor correctly it
could, for example, use the clock divisor code provided by the
manufacturer to slow down and speed up the CPU when required.

The question is: how to differentiate this chip from the Cyrix part?
The freely available "brief data sheet" does not provide much detail.

I have thought of a couple of schemes but am not really keen on either:

1) Clock speed - the SoC runs at 300+ MHz while the Cyrix part is < 100 MHz
2) Look at the PCI VID/PID for the north bridge as this is part of the CPU die.

Does anyone have any suggestions? Thanks.
