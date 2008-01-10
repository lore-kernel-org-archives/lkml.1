Return-Path: <linux-kernel-owner+w=401wt.eu-S1759217AbYAJIoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759217AbYAJIoT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 03:44:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755019AbYAJIoH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 03:44:07 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:55030 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753653AbYAJIoG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 03:44:06 -0500
Message-ID: <399954652.04868@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Thu, 10 Jan 2008 16:43:41 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: jplatte@naasa.net
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: regression: 100% io-wait with 2.6.24-rcX
References: <200801071151.11200.lists@naasa.net> <20080110073046.GA3432@mail.ustc.edu.cn> <399951601.23683@ustc.edu.cn> <200801100937.56145.lists@naasa.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801100937.56145.lists@naasa.net>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.12-2006-07-14
Message-Id: <E1JCt0n-00048n-AD@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2008 at 09:37:53AM +0100, Joerg Platte wrote:
> Am Donnerstag, 10. Januar 2008 schrieb Fengguang Wu:
> > On Thu, Jan 10, 2008 at 03:30:46PM +0800, Fengguang Wu wrote:
> > > Joerg,
> > >
> > > Can you try the attached patches? Thank you.
> > > I cannot reliably reproduce the bug yet.
> >
> > Please ignore the first patch and only apply the two debugging
> > patches. They will produce many printk messages. The output of
> > `dmesg` will be enough for me.
> 
> Too late, I'm already compiling the kernel. But I have currently another 

It won't hurt, as you don't use XIP.

> problem, because the iowait problem disappeared today after the regular 
> Debian update. I'll try to install the old package versions to make it show 
> up again. Maybe that helps to debug it.

Thank you. I'm running sid, ext2 as rootfs now ;-)

