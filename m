Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758170Ab0BMXup (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 18:50:45 -0500
Received: from lon1-post-1.mail.demon.net ([195.173.77.148]:56550 "EHLO
	lon1-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758065Ab0BMXuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 18:50:44 -0500
Message-ID: <4B773B31.1020802@lougher.demon.co.uk>
Date: Sat, 13 Feb 2010 23:52:17 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Pavel Machek <pavel@ucw.cz>, lasse.collin@tukaani.org, mirrors@kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "FTPAdmin Kernel.org" <ftpadmin@kernel.org>, users@kernel.org
Subject: Re: [kernel.org users] XZ Migration discussion
References: <4B744E13.8040004@kernel.org> <20100211205129.GA26105@elf.ucw.cz> <20100213181008.479509f5@hyperion.delvare>
In-Reply-To: <20100213181008.479509f5@hyperion.delvare>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean Delvare wrote:

> 
> Compared to bz2, gz saves... 2% on the overall time. As a conclusion, I
> think we can plain discard the argument "I need .gz because my machine
> is slow" from now on. It simply doesn't hold.
> 

I agree, but, IMHO the main argument for keeping .gz is cross-platform
availability and wide language support, not hardware limitations.  Doing
a quick google brings up .gz interfaces for every language you can think
of (C, Java, Perl, Python, TCL etc.), not to mention complete separate
implementations in Java and Pascal (not just wrappers on top of the zlib
library), and probably more.

With xz you have just one C/C++ implementation with a single library with
an undocumented API for C/C++ programmers.

It may be a slight stretch of the imagination, but with with .gz you can
conceive programmers writing programs to download a .gz from kernel.org and
decompressing/searching it, in almost any language of choice.  With the JAVA
implementation .gz is genuinely cross platform and you don't need glibc/
C++ compilers, just a Java VM.  Contrast with xz, where if the xz utility
isn't available, or doesn't do what you want, you're stuck with programming
in C/C++ with all the baggage that entails.

Phillip


