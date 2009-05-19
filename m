Return-Path: <linux-kernel-owner+w=401wt.eu-S1754009AbZESL6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009AbZESL6s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 07:58:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752949AbZESL6m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 07:58:42 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:33736 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305AbZESL6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 07:58:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=rNJNAE/7XifVpHr+cepj1q81PBTS4YrfJT8GAs9rrZxVqsai8h9XZPnt0R8evhdukc
         aFdL8dVgMwxlMEi3edk0j/ffdNs84Rb+HF5QRyq+PPAXaqk7g8ZCL4akWryh6NSZJgk2
         CrrPjHyOFOikZWr0uGqS94PYXtoaX4gDu6vvo=
MIME-Version: 1.0
Date: Tue, 19 May 2009 13:58:41 +0200
Message-ID: <29f1ba300905190458y44c8aadeuc8ff914e09105a09@mail.gmail.com>
Subject: Feasibility study: Linux on core 0, using other cores as worker 
	cores. Octeon II
From: linux kernel <linuxk3rnel@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This might seem as an unusal feasibility question, but I would like to
discuss this here at LKML to hear you views on this matter.
The idea would be to build a IBM cell blade lookalike architecture,
using full blown linux on core 0, using the other cores as worker
threads.
Possible target CPUs are Octeon II with 32 cores or more.

The main goal for this would be to reduce interrupt latency for worker
cores, having them run possibly bare-bone with an IPC method between
core 0 and worker cores. probably DMA and HW IRQs.

Is there an existing system design in the kernel already that I can
expand/use ? Perhaps expanding/porting the cell blade IPC method.
What would you guys think would be the most efficient approach(and
perhaps would be acceptable to the LK maintainers for merging at a
later stage :) )  ?

Best Regards,
David
