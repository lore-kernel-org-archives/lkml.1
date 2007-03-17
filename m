Return-Path: <linux-kernel-owner+w=401wt.eu-S1751786AbXCQXBu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751786AbXCQXBu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 19:01:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752207AbXCQXBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 19:01:50 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:63109 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786AbXCQXBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 19:01:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=Ek8WkFAzcAph1e+HkRJfOtm1xtPHqRgKxrUuYDQLH2mbsYRfNayWQNqDFH1ppT7LS92FdWxOGTaQ38r8jKE/YyEeoOW/XduyGeAVQUsKD1hCPq8ne1GqWOxVeJZ5BIJAXsSyE6zIfI7ZYexyzfguG7rMMcGHwbfdVZPXGHuMzQo=
From: Maxim <maximlevitsky@gmail.com>
To: tglx@linutronix.de
Subject: Re: [BUG] 2.6.21-rc1,2,3 regressions on my system that I found so far
Date: Sun, 18 Mar 2007 01:01:44 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <200703161230.03712.maximlevitsky@gmail.com> <1174088342.13341.340.camel@localhost.localdomain>
In-Reply-To: <1174088342.13341.340.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703180101.44668.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 17 March 2007 01:39:01 Thomas Gleixner wrote:
> On Fri, 2007-03-16 at 12:30 +0200, Maxim Levitsky wrote:
> > Mar 14 00:22:23 MAIN kernel: [    2.072875] caller is check_tsc_sync_source+0x1d/0x100
> > Mar 14 00:22:23 MAIN kernel: [    2.072878]  [show_trace_log_lvl+26/48] show_trace_log_lvl+0x1a/0x30
> > Mar 14 00:22:23 MAIN kernel: [    2.072931] checking TSC synchronization [CPU#0 -> CPU#1]:
> > Mar 14 00:22:23 MAIN kernel: [    2.092922] Measured 72051818872 cycles TSC warp between CPUs, turning off
> > 
> > It looks clear that preempt is enabled all the way in second cpu initialization, ( I think that at least in check_tsc_sync_source, it should be disabled,
> > shouldn't it ? )
> 
> This should be fixed by commit d04f41e35343f1d788551fd3f753f51794f4afcf
> 
> 	tglx
> 
> 
> 
> 

Hi,

Yes, it is fixed, thanks

Regards,
	Maxim Levitsky
