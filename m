Return-Path: <linux-kernel-owner+w=401wt.eu-S932423AbXBPUJ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932423AbXBPUJ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 15:09:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946091AbXBPUJ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 15:09:28 -0500
Received: from mx1.redhat.com ([66.187.233.31]:58454 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932423AbXBPUJ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 15:09:27 -0500
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20070216165042.GB409@lnx-holt.americas.sgi.com> 
References: <20070216165042.GB409@lnx-holt.americas.sgi.com>  <45D5B483.3020502@hitachi.com> <45D5B2E3.3030607@hitachi.com> <20368.1171638335@redhat.com> 
To: Robin Holt <holt@sgi.com>
Cc: "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>,
       Andrew Morton <akpm@osdl.org>,
       kernel list <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi OSHIMA <soshima@redhat.com>,
       "Hideo AOKI@redhat" <haoki@redhat.com>
Subject: Re: [PATCH 3/4] coredump: ELF-FDPIC: enable to omit anonymous shared memory 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Fri, 16 Feb 2007 20:09:03 +0000
Message-ID: <18817.1171656543@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robin Holt <holt@sgi.com> wrote:

> How about:
> 		if (vma->vm_mm->coredump_omit_anon_shared) {
> 
> Then the calls to maydump() would be unchanged:

VMAs are a shared resource under NOMMU conditions.

David
