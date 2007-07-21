Return-Path: <linux-kernel-owner+w=401wt.eu-S937553AbXGULeH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937553AbXGULeH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 07:34:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932859AbXGULdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 07:33:54 -0400
Received: from www.osadl.org ([213.239.205.134]:54152 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932213AbXGULdx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 07:33:53 -0400
Subject: Re: PROBLEM: Dell Inspiron 1501 fails to boot in 2.6.21+
From: Thomas Gleixner <tglx@linutronix.de>
To: Mark Tiefenbruck <mark@fluxbox.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <c96265a60707201937t39f9b69ep48e76ed61ce1044e@mail.gmail.com>
References: <c96265a60707201937t39f9b69ep48e76ed61ce1044e@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 21 Jul 2007 13:33:51 +0200
Message-Id: <1185017631.4012.111.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-07-20 at 19:37 -0700, Mark Tiefenbruck wrote:
> My new laptop won't boot with kernel versions 2.6.21 or 2.6.22 . No
> oops. No panic. It just stops printing messages. Maybe it would
> eventually continue if I wait long enough, but it's unacceptable
> either way. I include below the contents of dmesg for a working kernel
> up to the point where it halts. I'm also including what it usually
> does for a few lines after that point.

Can you please try the following command line options in any
combination:

hpet=disable
nohz=off
highres=off
nolapic_timer

Thanks,

	tglx




