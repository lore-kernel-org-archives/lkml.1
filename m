Return-Path: <linux-kernel-owner+w=401wt.eu-S964844AbXDMUCG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964844AbXDMUCG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 16:02:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964852AbXDMUCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 16:02:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54108 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964844AbXDMUCF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 16:02:05 -0400
Date: Fri, 13 Apr 2007 16:02:02 -0400
From: Dave Jones <davej@redhat.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: i8042 lockdep false positive.
Message-ID: <20070413200202.GC27682@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20070413191415.GA27682@redhat.com> <d120d5000704131218x4e0485d7vbc290d1821a65ca3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d120d5000704131218x4e0485d7vbc290d1821a65ca3@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2007 at 03:18:32PM -0400, Dmitry Torokhov wrote:
 > Hi Dave,
 > 
 > On 4/13/07, Dave Jones <davej@redhat.com> wrote:
 > > I just had a user file the report below, which iirc, was deemed a false
 > > positive.  Didn't we add something to the code so that lockdep would
 > > ignore what this was doing ?  Did we regress?
 > >
 > 
 > For some reasn lockdep annotations cease to work when you reload
 > psmouse module. I did not have time to look further.

In the case reported, psmouse was non-modular.

	Dave

-- 
http://www.codemonkey.org.uk
