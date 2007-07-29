Return-Path: <linux-kernel-owner+w=401wt.eu-S1762160AbXG2LaQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762160AbXG2LaQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 07:30:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761471AbXG2LaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 07:30:05 -0400
Received: from smtp-out3.blueyonder.co.uk ([195.188.213.6]:58949 "EHLO
	smtp-out3.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761488AbXG2LaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 07:30:04 -0400
From: Alistair John Strachan <alistair@devzero.co.uk>
To: Avi Kivity <avi@qumranet.com>
Subject: Re: 2.6.23-rc1, KVM-AMD problem
Date: Sun, 29 Jul 2007 12:29:48 +0100
User-Agent: KMail/1.9.7
Cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <200707281855.41277.alistair@devzero.co.uk> <46AC4CEB.9060401@qumranet.com>
In-Reply-To: <46AC4CEB.9060401@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707291229.49155.alistair@devzero.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 29 July 2007 09:16:43 Avi Kivity wrote:
> Alistair John Strachan wrote:
> > Hi,
> >
> > I'm getting periodic oopses running KVM-33 on 2.6.23-rc1. Here is a
> > digital photo of the oops. Alarmingly, a lot of the time it triple faults
> > the machine and I don't get a chance to grab it. This time I was lucky,
> > though.
> >
> > http://devzero.co.uk/~alistair/kvm-2.6.23-rc1.jpg
> >
> > Unfortunately, some of the oops text scrolled out of the screen. I will
> > endeavour to reproduce the bug over serial console, but I can make no
> > guarantees.
> >
> > The CPU is an AMD X2 BE-2350, chipset is AMD 690G.
>
> If you are using the modules from 2.6.23-rc1, try upgrading to latest
> -git, which contains a patch that might fix this problem.  If you are
> using the modules from kvm-33, try applying the attached patch.

Doesn't help, I still get the same crashes. I tried 2.6.22 again and it's rock 
solid by comparison.

-- 
Cheers,
Alistair.

137/1 Warrender Park Road, Edinburgh, UK.

