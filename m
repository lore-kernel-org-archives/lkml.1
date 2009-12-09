Return-Path: <linux-kernel-owner+w=401wt.eu-S967022AbZLIApH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967022AbZLIApH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 19:45:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966996AbZLIApD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 19:45:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29549 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966998AbZLIApD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 19:45:03 -0500
Message-ID: <4B1EF303.60208@redhat.com>
Date: Tue, 08 Dec 2009 19:44:51 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: origin (tip) tree build warning
References: <20091209104216.94249b11.sfr@canb.auug.org.au>
In-Reply-To: <20091209104216.94249b11.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi all,
> 
> Today's (and probably several earlier) linux-next build (x86_64
> allmodconfig) produced this warning:
> 
> arch/x86/tools/test_get_len.c: In function 'main':
> arch/x86/tools/test_get_len.c:116: warning: unused variable 'c'
> 
> Introduced by commit d65ff75fbe6f8ac7c17f18e4108521898468822c ("x86: Add
> verbose option to insn decoder test").
> 

Ah, this warning has been fixed on tip:perf/urgent by commit be2bf0a2.

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

