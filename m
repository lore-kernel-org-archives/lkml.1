Return-Path: <linux-kernel-owner+w=401wt.eu-S1751772Ab0ACScZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751772Ab0ACScZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 13:32:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751686Ab0ACScY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 13:32:24 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:62880 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608Ab0ACScX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 13:32:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=XGFRGLmpCmo7L2ultbgRX+s0Y4DwoKJOqCtl8k4AX9j4k+VBliBVwDfwLfIUVhDrQa
         IIUQ/pLlcK1Xq0S80h6l1qg+PCZpkhkUio4DNoGFbDSzeU4sdgUfJvVCiuspvucZlJF2
         HwIhdltimWqGAr6CuCPcOsQ6FQ6GlHai7adzA=
From: Marek Vasut <marek.vasut@gmail.com>
Organization: Hack&Dev
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] stack2core: show stack message and convert it to core file when kernel die
Date: Sun, 3 Jan 2010 19:32:11 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-1-amd64; KDE/4.3.2; x86_64; ; )
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
       Hui Zhu <teawater@gmail.com>, linux-mips@linux-mips.org,
       Catalin Marinas <catalin.marinas@arm.com>, Coly Li <coly.li@suse.de>,
       Paul Gortmaker <Paul.Gortmaker@windriver.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       David Daney <ddaney@caviumnetworks.com>, Chris Dearman <chris@mips.com>,
       Ingo Molnar <mingo@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       saeed bishara <saeed.bishara@gmail.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, Brian Gerst <brgerst@gmail.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Nicolas Pitre <nico@fluxnic.net>, "Greg Kroah-Hartman" <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
       Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
References: <daef60381001030705r93b3fbfkc50e7b9bbc62b334@mail.gmail.com> <daef60381001030939r60315c1dy56025a041a8ee758@mail.gmail.com> <20100103174737.GD21156@n2100.arm.linux.org.uk>
In-Reply-To: <20100103174737.GD21156@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001031932.11210.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne Ne 3. ledna 2010 18:47:37 Russell King - ARM Linux napsal(a):
> On Mon, Jan 04, 2010 at 01:39:44AM +0800, Hui Zhu wrote:
> > scripts/markup_oops.pl just support x86?
> > s2c support x86, x8664, arm, mips, mips64.
> 
> I'm sure there's patches around to make it work on ARM, or if not,
> there soon will be.

And if there are not, that's the place you should focus yourself on rather than 
duplicating work ...

> There's certainly patches around at the moment
> to make scripts/decodecode work on ARM.
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 
