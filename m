Return-Path: <linux-kernel-owner+w=401wt.eu-S1754026AbYGEQ3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026AbYGEQ3Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 12:29:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751655AbYGEQ3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 12:29:17 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:2694 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbYGEQ3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 12:29:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent:sender;
        b=NUy/L3IIUF08WVwpo9YfHecch8oK22H/S47pMxG3DcyHOR6QToGp4j/lOgQSAVSUFa
         7h5Tbzqbp5/vGrHycMhs3AsaVk3cloLsj9hQWeLjOU9W449qAmgqgkLwsPlj5iNBIc+U
         2Zykl4DTKsDQbv5VTYIQYkeL5NoRyRY1JSuus=
Date: Sat, 5 Jul 2008 21:59:04 +0530
From: Rabin Vincent <rabin@rab.in>
To: Bradley Hanna <brahan.ml@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Creating syscalls: Under an x86_64 arch, where is the syscall
	table located?
Message-ID: <20080705162903.GA1861@debian>
References: <486F8D55.2060506@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <486F8D55.2060506@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 05, 2008 at 11:03:49AM -0400, Bradley Hanna wrote:
> I am trying to create a syscall for testing purposes.  I have a kernel
> configured for x86_64 arch and need to know where the syscall table is
> located.  I believe I have found the unistd.h file that I need under
> 'include/asm/unistd_64.h' but I cannot find a file containing the
> 'sys_call_table' that corresponds with that 'unistd_64.h' file.  I can
> find a file called syscall_table_32.S, but no table for 64.  The table
> is no longer located in entry.S, so where do I find it?  The
> '__syscallN' macro is not finding my syscall definition.

sys_call_table for x86_64 is defined in arch/x86/kernel/syscall_64.c.

Rabin
