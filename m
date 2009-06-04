Return-Path: <linux-kernel-owner+w=401wt.eu-S1752780AbZFDUKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780AbZFDUKh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 16:10:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752968AbZFDUK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 16:10:28 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:60278 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753507AbZFDUK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 16:10:26 -0400
Date: Thu, 4 Jun 2009 22:12:42 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Russell King <rmk+lkml@arm.linux.org.uk>,
       Catalin Marinas <catalin.marinas@arm.com>,
       Tony Luck <tony.luck@intel.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Greg Ungerer <gerg@snapgear.com>, Ralf Baechle <ralf@linux-mips.org>,
       Michael Abbott <michael@araneidae.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 0/6] headers_check fix patches 20090604
Message-ID: <20090604201242.GB13892@uranus.ravnborg.org>
References: <1244118232.5172.26.camel@ht.satnam>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244118232.5172.26.camel@ht.satnam>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 04, 2009 at 05:53:52PM +0530, Jaswinder Singh Rajput wrote:
> Please Review :
> 
> Jaswinder Singh Rajput (6):
>       headers_check fix: arm, hwcap.h
>       headers_check fix: ia64, fpswa.h
>       headers_check fix: m68k, swab.h
>       headers_check fix: mips, ioctl.h
>       headers_check fix: mn10300, ptrace.h
>       headers_check fix: mn10300, setup.h

Please let the subject explain what was fixed.
The fact that you used headers_check to detect the
issue in the first place is less relevant.

For mips the subject could have been:

mips: use userspace compatible definition of _IOC_TYPECHECK

Did you concentrate solely on headers_check output
or did you carefully inspect the files you touched for userspace issues?
I stroingly recommend to fix all userspace issues in files touched
if this is possible.

	Sam
