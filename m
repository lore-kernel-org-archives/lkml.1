Return-Path: <linux-kernel-owner+w=401wt.eu-S1755555AbZCEVOu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555AbZCEVOu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 16:14:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753295AbZCEVOl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 16:14:41 -0500
Received: from hera.kernel.org ([140.211.167.34]:41115 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750902AbZCEVOk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 16:14:40 -0500
Subject: [x86-tip] overflow in relocation type 11 val 39ffdd0e8690
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 06 Mar 2009 02:44:14 +0530
Message-Id: <1236287654.3677.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.4 (2.24.4-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On latest tip I am getting:

[  124.169475] overflow in relocation type 11 val 39ffdd0e8690
[  124.169508] `msr_debug' likely not compiled with -mcmodel=kernel
[  146.582299] overflow in relocation type 11 val 39ffdd0e8690
[  146.582299] `msr_debug' likely not compiled with -mcmodel=kernel
[  836.653168] overflow in relocation type 11 val 39ffdd0e8690
[  836.653201] `msr_debug' likely not compiled with -mcmodel=kernel

But 1d10914bf2c8 was working fine.

Thanks,
--
JSR

