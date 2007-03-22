Return-Path: <linux-kernel-owner+w=401wt.eu-S934205AbXCVTuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934205AbXCVTuq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 15:50:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934207AbXCVTuq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 15:50:46 -0400
Received: from faui03.informatik.uni-erlangen.de ([131.188.30.103]:58372 "EHLO
	faui03.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934205AbXCVTup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 15:50:45 -0400
Date: Thu, 22 Mar 2007 20:50:43 +0100
From: Thomas Glanzmann <thomas@glanzmann.de>
To: LKML <linux-kernel@vger.kernel.org>
Subject: MCE Erros
Message-ID: <20070322195043.GA19732@cip.informatik.uni-erlangen.de>
Mail-Followup-To: Thomas Glanzmann <thomas@glanzmann.de>,
	LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-23)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
I have two Dual Opteron Machines where I get two MCE errors on. The
first one is:

        MCE 0
        HARDWARE ERROR. This is *NOT* a software problem!
        Please contact your hardware vendor
        CPU 0 4 northbridge TSC edc587de6e99
        ADDR 1001a0000
          Northbridge GART error
               bit61 = error uncorrected
          TLB error 'generic transaction, level generic'
        STATUS a40000000005001b MCGSTATUS 0

I see this error exactly 8 times. What does 'GART' mean?

And here is another one another box:

        MCE 0
        HARDWARE ERROR. This is *NOT* a software problem!
        Please contact your hardware vendor
        CPU 1 4 northbridge TSC f23151075b21d
        ADDR b8898250
          Northbridge Chipkill ECC error
          Chipkill ECC syndrome = f858
               bit32 = err cpu0
               bit46 = corrected ecc error
               bit62 = error overflow (multiple errors)
          bus error 'local node origin, request didn't time out
              generic read mem transaction
              memory access, level generic'
        STATUS d42c4001f8080813 MCGSTATUS 0

How do I identify the broken Memory Modules?

        Thomas
