Return-Path: <linux-kernel-owner+w=401wt.eu-S1755968AbYJYAVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968AbYJYAVg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 20:21:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752253AbYJYAV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 20:21:29 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:43512 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752184AbYJYAV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 20:21:28 -0400
Subject: [PATCH 0/4] V3 Hypervisor detection and tsc_reliable feature
	definition
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Daniel Hecht <dhecht@vmware.com>
Content-Type: text/plain
Organization: VMware INC.
Date: Fri, 24 Oct 2008 17:21:27 -0700
Message-Id: <1224894087.28224.69.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

These patches define a framework for hypervisor detection and setting of
hypervisor feature bits. We define a X86_FEATURE_TSC_RELIABLE bit which
is a synthetic bit. This is set when running under VMware. This  feature
bit is used to skip TSC checks which can fail on virtualization platform
due to timing differences when running on virtual cpus.

Thanks,
Alok


