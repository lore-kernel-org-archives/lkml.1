Return-Path: <linux-kernel-owner+w=401wt.eu-S934189AbZJIUFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934189AbZJIUFy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 16:05:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761340AbZJIUFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 16:05:53 -0400
Received: from isrv.corpit.ru ([81.13.33.159]:43579 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761346AbZJIUFx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 16:05:53 -0400
Message-ID: <4ACF977B.7060104@msgid.tls.msk.ru>
Date: Sat, 10 Oct 2009 00:05:15 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: wrong final bzImage build (regading #14270)
References: <4ACF460E.7000901@msgid.tls.msk.ru> <20091009145825.GE5311@lenovo> <4ACF9184.9040104@msgid.tls.msk.ru>
In-Reply-To: <4ACF9184.9040104@msgid.tls.msk.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Tokarev wrote:
> Ok, some more to this.
> 
> It turns out dash's built-in echo command interprets \nnn octal
> sequences by default, and there's no way to turn that off.  So,
> for example, sed-zoffset command from arch/x86/boot/Makefile
> (which includes \1 \2 etc substitutions for sed), when echoed
> in verbose mode (V=1), produces.. interesting characters (with
> ascii code 1 and 2).
> 
> It's not practival to replace V=1's echo with /bin/echo I think.
> 
> So I'd say it's not a bug in the build system after all, but
> a bug in dash.  Well, at least this expanding-by-default didn't
> trigger another very-difficult-to-find bug (hopefully), but it
> has good potential.
> 
> I'll file a bug report against dash.

For reference: http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=550399

> /mjt

