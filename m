Return-Path: <linux-kernel-owner+w=401wt.eu-S1756389AbZJSOO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756389AbZJSOO5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 10:14:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756364AbZJSOO4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 10:14:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42887 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756355AbZJSOOy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 10:14:54 -0400
Date: Mon, 19 Oct 2009 16:14:57 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>,
       Bob Moore <robert.moore@intel.com>, Lin Ming <ming.m.lin@intel.com>,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH 6/7] acpi: fix trivial warning
In-Reply-To: <1255906474-25091-7-git-send-email-felipe.contreras@gmail.com>
Message-ID: <alpine.LSU.2.00.0910191614150.8582@wotan.suse.de>
References: <1255906474-25091-1-git-send-email-felipe.contreras@gmail.com> <1255906474-25091-7-git-send-email-felipe.contreras@gmail.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Oct 2009, Felipe Contreras wrote:

> drivers/acpi/acpica/tbfadt.c: In function ?acpi_tb_create_local_fadt?:
> arch/x86/include/asm/string_32.h:74: warning: array subscript is above array bounds

Same is in your previous patch -- what gcc is that? I don't see any 
warning with 4.3.1

$ make drivers/acpi/acpica/tbfadt.o
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  SYMLINK include/asm -> include/asm-x86
  CALL    scripts/checksyscalls.sh
  CC      drivers/acpi/acpica/tbfadt.o
$

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
