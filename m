Return-Path: <linux-kernel-owner+w=401wt.eu-S1759977AbYEXSw5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759977AbYEXSw5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 14:52:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757120AbYEXSwr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 14:52:47 -0400
Received: from mailout04.t-online.de ([194.25.134.18]:58251 "EHLO
	mailout04.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756628AbYEXSwr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 14:52:47 -0400
To: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: CONFIG_PREEMPT causes corruption of application's FPU stack
Cc: linux-kernel@vger.kernel.org
Content-Disposition: inline
From: j.mell@t-online.de
Reply-To: j.mell@t-online.de
Date: Sat, 24 May 2008 20:52:30 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <200805242052.30303.j.mell@t-online.de>
X-ID: GMOxQsZvQhYXZSBhkEBbzynDCwFe9wREhlfTevwGfig7iM1tmRQpSqmtU2BoS5YZRW
X-TOI-MSGID: c4fa1a40-00e2-4d17-b86c-fee17ed224e8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sonday, 18. May 2008, you wrote:
> > On Sat, May 17, 2008 at 06:31:08PM +0200, J?rgen Mell wrote:
> > > I tracked this down to a single kernel configuration option. If
> > > CONFIG_PREEMPT is set to 'y' the application will start crashing. If
> > > CONFIG_PREEMPT is replaced by CONFIG_PREEMPT_VOLUNTARY, the
> > > application will run without errors.

> > If you see it in the kernel.org kernel, can you please do a git-bisect
> > to see which commit caused the problem?

> This is a bit of a problem. I do not know whether there was *ever* a
> kernel  version with CONFIG_PREEMPT and without this problem as I have
> not tried  any older kernel version yet. I will go back to SUSE 10.2 and
> try the  2.6.18 kernel that comes with it.

I found now that the problem was introduced somewhere between the 
kernel.org kernels 2.6.19.7 and 2.6.20. I will start bisecting now.

Bye,

          Jürgen
