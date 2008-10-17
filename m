Return-Path: <linux-kernel-owner+w=401wt.eu-S1757924AbYJQUMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757924AbYJQUMm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 16:12:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755710AbYJQUMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 16:12:35 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:9429 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090AbYJQUMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 16:12:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=jKubJ5da0FLQeaT0k3XFiFkiWJTOTr2QhOaMPb5NvMsML81RPD1DcWCRLmZxDxxm8O
         2UMosfMSiMvZv2G5k12mAtNYACpfUnS2ey+thjeTfmOR1Tu1brpBUEGTX/s6cYUasj9l
         DHPDZLlN7nxg+Gu883yFhQI/j2H3yqtSX1u9g=
Message-ID: <b637ec0b0810171312y2bc88085o7973c257713b0d5c@mail.gmail.com>
Date: Fri, 17 Oct 2008 22:12:33 +0200
From: "Fabio Comolli" <fabio.comolli@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Latest GIT section mismatches
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus ' GIT  2.6.27-05323-g26e9a39 (pulled less than one hour ago) gives:

WARNING: vmlinux.o(.text+0x1cde2): Section mismatch in reference from
the function reserve_region_with_split() to the function
.init.text:__reserve_region_with_split()
The function reserve_region_with_split() references
the function __init __reserve_region_with_split().
This is often because reserve_region_with_split lacks a __init
annotation or the annotation of __reserve_region_with_split is wrong.

WARNING: vmlinux.o(.cpuinit.text+0xeec): Section mismatch in reference
from the function cpu_init() to the function
.init.text:init_thread_xstate()
The function __cpuinit cpu_init() references
a function __init init_thread_xstate().
If init_thread_xstate is only used by cpu_init then
annotate init_thread_xstate with a matching annotation.

WARNING: vmlinux.o(.cpuinit.data+0x0): Section mismatch in reference
from the variable initial_code to the function
.init.text:i386_start_kernel()
The variable __cpuinitdata initial_code references
a function __init i386_start_kernel().
If i386_start_kernel is only used by initial_code then
annotate i386_start_kernel with a matching annotation.

I'll send .config on request.
