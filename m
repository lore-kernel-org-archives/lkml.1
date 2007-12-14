Return-Path: <linux-kernel-owner+w=401wt.eu-S1761314AbXLNIMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761314AbXLNIMZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 03:12:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754881AbXLNIMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 03:12:17 -0500
Received: from gw.goop.org ([64.81.55.164]:42960 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754791AbXLNIMQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 03:12:16 -0500
Message-ID: <47623ACF.3050108@goop.org>
Date: Fri, 14 Dec 2007 00:11:59 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jan Beulich <jbeulich@novell.com>,
       Glauber de Oliveira Costa <glommer@gmail.com>
Subject: [PATCH 0/4] pagetable unification: this time for sure!
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a new set of patches.  I've compiled tested:

    * 32-bit PAE paravirt
    * 32-bit non-PAE paravirt
    * 32-bit PAE non-paravirt
    * 32-bit non-PAE non-paravirt
    * 64-bit

and test-booted them to usermode under kvm (though I'm currently typing
this under 32-bit PAE paravirt).

The patches are based on linux-2.6-x86.git commit
022b7918fe3ac93ea171558e95d391efe82af4bb.

The net effect of these patches is little more than refactoring and code
motion, though I wouldn't expect the generated code to be identical.

    J
