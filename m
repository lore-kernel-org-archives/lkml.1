Return-Path: <linux-kernel-owner+w=401wt.eu-S1422956AbXBHMLL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422956AbXBHMLL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 07:11:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422962AbXBHMLL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 07:11:11 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:44585 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422956AbXBHMLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 07:11:09 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: vgoyal@in.ibm.com
Cc: Etienne Lorrain <etienne_lorrain@yahoo.fr>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: Re : [PATCH] Compressed ia32 ELF file generation for loading by Gujin 1/3
References: <20070208094831.56920.qmail@web26908.mail.ukl.yahoo.com>
	<20070208113706.GB14039@in.ibm.com>
Date: Thu, 08 Feb 2007 05:10:43 -0700
In-Reply-To: <20070208113706.GB14039@in.ibm.com> (Vivek Goyal's message of
	"Thu, 8 Feb 2007 17:07:06 +0530")
Message-ID: <m1bqk4alz0.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@in.ibm.com> writes:

> Kexec as a boot loader allows to load both ELF vmlinux file or bzImage.
> Hence for kdump, a user got the flexibility to either use vmlinux or 
> bzImage for dump captruing purposes. Hence I am concerned about both. 
>
> If real mode code is linked with vmlinux, then kdump will be broken.
>
> bzImage is relocatable. If a new kernel image format is introduced
> (compressed ELF), then I will prefer it to be a relocatable one
> (if possible).

If we do make the real mode code findable from a set of ELF headers
instead of a weird program header it should be an ELF note in the note
segment that tells us where to find or possibly contains the real mode
code.

Eric
