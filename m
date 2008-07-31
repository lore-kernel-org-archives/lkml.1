Return-Path: <linux-kernel-owner+w=401wt.eu-S1755512AbYGaNvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512AbYGaNvT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 09:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752630AbYGaNvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 09:51:05 -0400
Received: from fk-out-0910.google.com ([209.85.128.186]:18095 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361AbYGaNvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 09:51:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=etd77RB/fBv8v5oGa/stjdGXvuBS9c6cJQ09XlkOKq/XRAsEF08kz3BkFmMof3hEXM
         AMkXciHAAa+DRPZdCIIIt/eriy14E/+V02BnhfBsGxm+f+Pgiy2t0lnpky5I8ziq4bnE
         OmVduykXNWijSYlcYZWbnQ8KuEf8r+PwEZgcQ=
Date: Thu, 31 Jul 2008 17:50:58 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Sysrq+B doesn't work on my box
Message-ID: <20080731135058.GA31888@martell.zuzino.mipt.ru>
References: <c4e36d110807310645n3ff6e61j17414433c5aee030@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c4e36d110807310645n3ff6e61j17414433c5aee030@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2008 at 03:45:24PM +0200, Zdenek Kabelac wrote:
> Hi
> 
> I'd like to get resolved this problem - my T61 machine doesn't reboot
> with SysRQ+B key.
> And I never remember if it was ever rebooting.
> 
> This is all I know so far and I've no idea where could be the problem.
> 
> System is running Fedora rawhide 64bit.
> 
> If I press any other  SysRQ combination - it works - so things like
> Sync, Umount, powerOff do work normally.
> It's just Boot  which does not even get to the  __handle  routine
> (I've added one extra simple debug prinkt
> for this case)
> 
> So - who/how/where could mask this key sequence from being delivered
> to the sysrq driver?
> (obviously I do not have any problems typing letter 'b' itself)
> 
> 
> 
> Another issue is - that even with  'echo b >/proc/sysrq-triggers' my
> machine doesn't reboot.

Typo here? Do

	/bin/echo b >/proc/sysrq-trigger

(sic)

