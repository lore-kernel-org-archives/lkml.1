Return-Path: <linux-kernel-owner+w=401wt.eu-S1756488AbXJBXA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756488AbXJBXA4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 19:00:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753037AbXJBXAu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 19:00:50 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:24489 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647AbXJBXAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 19:00:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=X0oN9YxXfy+zvAsLys4luuXELFy4PUVcgxInBQVINrgyhI9hhlpCiRPOTCrW7BuwiQhdAPg6CSmxNFk5q2ug3otoL5VeYGM1XQ6YBw/4dpFEOJqvqBFZT/EbPnirzsU+aM6eB+Z9ChV8Z3yMrKIzSMPkouwu5JykvNObUp/Iyh4=
Message-ID: <5d6222a80710021600tb42532bhd4001060b464bb48@mail.gmail.com>
Date: Tue, 2 Oct 2007 20:00:46 -0300
From: "Glauber de Oliveira Costa" <glommer@gmail.com>
To: "Alistair John Strachan" <alistair@devzero.co.uk>
Subject: Re: Linux 2.6.23-rc9 and a heads-up for the 2.6.24 series..
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andi Kleen" <ak@suse.de>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Sam Ravnborg" <sam@ravnborg.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <200710022351.48971.alistair@devzero.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.0.999.0710012029400.3579@woody.linux-foundation.org>
	 <200710022351.48971.alistair@devzero.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/2/07, Alistair John Strachan <alistair@devzero.co.uk> wrote:
> This is certainly a tool issue, but if I use Debian's kernel-image "make-kpkg"
> wrapper around the kernel build system, it fails with:
>
> cp: cannot stat `arch/x86_64/boot/bzImage': No such file or directory
>
> Obviously, this file has moved to arch/x86/boot, but it seems like possibly
> unnecessary breakage. I've been copying bzImage for years from
> arch/x86_64/boot, and I'm sure there's a handful of scripts (other than
> Debian's kernel-image) doing this too.

I believe most sane tools would be using the output of uname -m, so a
possible way to fix this would be fixing the data passed to userspace
from uname. However, that might be the case that it creates a new set
of problems too, with tools relying on the output of uname -m to
determine wheter the machine is 32 or 64 bit, and so on.

-- 
Glauber de Oliveira Costa.
"Free as in Freedom"
http://glommer.net

"The less confident you are, the more serious you have to act."
