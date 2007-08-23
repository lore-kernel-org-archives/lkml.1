Return-Path: <linux-kernel-owner+w=401wt.eu-S1758648AbXHWAdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758648AbXHWAdS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 20:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752138AbXHWAdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 20:33:08 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38273 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751264AbXHWAdH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 20:33:07 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andi Kleen <ak@suse.de>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@sw.ru>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc3-mm1: cannot stat `vdso.so.dbg'
In-Reply-To: Andi Kleen's message of  Thursday, 23 August 2007 01:57:48 +0200 <200708230157.48526.ak@suse.de>
X-Zippy-Says: Yow!  I'm out of work...I could go into shock absorbers...or SCUBA GEAR!!
Message-Id: <20070823003232.603F04D0418@magilla.localdomain>
Date: Wed, 22 Aug 2007 17:32:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The problem is they're two patching consecutively patching the same
> file with 100% identical subject/description.
> 
> So either: they should be merged together into one patch
> or the second (or first) needs a new description/subject

They do the same thing for the x86_64 ia32-compat and x86_64 native vDSOs,
respectively. 

Subject: [PATCH 1/2] x86_64 ia32 vDSO: install unstripped copies on disk
Subject: [PATCH 2/2] x86_64 vDSO: install unstripped copies on disk

Andrew called them

x86_64-ia32-vdso-install-unstripped-copies-on-disk
x86_64-vdso-install-unstripped-copies-on-disk

The names/subjects are not identical, but differ in having "ia32" or not.
That is really the only difference between the two patches, too.

> TBD this needs a proper changelog/subject from Roland. I have no idea what 
> it does

I don't now what is unclear about the log entry.  Yes, each log entry says
the same thing after the first (Subject) line.  Each one relates to a
different arch/x86_64/subdirectory/Makefile that creates vDSO images.
Prepend "This applies to the x86_64/vdso native vDSO building." or
"This applies to the x86_64/ia32 vDSO building." to the log if you prefer.


Thanks,
Roland
