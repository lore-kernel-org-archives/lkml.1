Return-Path: <linux-kernel-owner+w=401wt.eu-S1762992AbYD0X4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762992AbYD0X4R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 19:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752038AbYD0Xz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 19:55:59 -0400
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:27869 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752602AbYD0Xz6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 19:55:58 -0400
Date: Mon, 28 Apr 2008 00:55:54 +0100
From: Ken Moffat <zarniwhoop@ntlworld.com>
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: Sergio Luis <sergio@larces.uece.br>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.25 slow boot/reboot
Message-ID: <20080427235554.GA28344@deepthought>
References: <48141111.7010605@larces.uece.br> <e2e108260804270823t45611ec2t35da085833d82dfa@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <e2e108260804270823t45611ec2t35da085833d82dfa@mail.gmail.com>
User-Agent: Mutt/1.5.12-2006-07-14
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2008 at 05:23:57PM +0200, Bart Van Assche wrote:
> On Sun, Apr 27, 2008 at 7:37 AM, Sergio Luis <sergio@larces.uece.br> wrote:
> >  This weekend I got some time and decided to try out 2.6.25, but its booting process was _really_ slow in my laptop[1]. With 'old' 2.6.24.5 my machine would take about 48 secs until it gave me the login prompt. And it would take about 22 seconds to reboot.
> 
> Do you use LILO or GRUB for booting ? 2.6.25 works OK on the systems I
> tested, but LILO really needs a lot of time to load the 2.6.25 kernel.
> GRUB loads the 2.6.25 kernel at normal speed.
> 
> Bart.
 ISTR that an _old_ version of lilo was mentioned earlier in this
thread.  As a datapoint, on my one desktop box which uses lilo (an
athlon64 uniprocessor) both 32 and 64-bit 2.6.25 kernels boot fine.
Both of those systems are with lilo-22.8, and gcc-4.2.2.

 But, I think you (Bart) haven't said which version of lilo you are
using ?  If it isn't recent, perhaps upgrading it might help ?

 For Sergio, you have my sympathy.  I totally failed to bisect my own
problem with 2.6.25-rc (and 2.6.24.1), although I did find the problem
by other means, and got a work-around, so I'm not competent to
diagnose what is wrong, but maybe I can help to tease out what is
different about your box.  As a start, you could try diffing your
config's for 2.6.24.5 and 2.6.25 in case something odd has changed.

 Or, perhaps this is a problem specific to a certain processor ?  So
far, I think all the list knows is that you have a problem, and an
old version of lilo.  More data might eventually help to identify
what is causing this.  If you have a fairly old version of lilo,
maybe you also have an old version of gcc ?

 For Bart too, which version(s) of gcc are you using on the systems
where lilo is slow to load, and which cpu(s) do you have there ?

Ken, who relies on lilo for his server, and gets worried by reports
of trouble with it.
-- 
das eine Mal als Tragödie, das andere Mal als Farce
