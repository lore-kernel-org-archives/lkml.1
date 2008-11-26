Return-Path: <linux-kernel-owner+w=401wt.eu-S1754776AbYKZRed@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776AbYKZRed (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 12:34:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752635AbYKZReY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 12:34:24 -0500
Received: from vpnflf.ccur.com ([12.192.68.2]:43587 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752387AbYKZReX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 12:34:23 -0500
Date: Wed, 26 Nov 2008 12:34:10 -0500
From: Joe Korty <joe.korty@ccur.com>
To: Greg KH <greg@kroah.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Linux API <linux-api@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Display active jiffie timers in /proc/timer_list, v2
Message-ID: <20081126173410.GA17879@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
References: <20081121221113.GA13566@tsunami.ccur.com> <517f3f820811250806n33850ea8ua8e203347c0f7ba6@mail.gmail.com> <20081125185740.GA21806@tsunami.ccur.com> <20081126164845.GA17394@tsunami.ccur.com> <20081126170715.GA28422@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081126170715.GA28422@kroah.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2008 at 12:07:15PM -0500, Greg KH wrote:
> On Wed, Nov 26, 2008 at 11:48:45AM -0500, Joe Korty wrote:
> > Add an 'active jiffie timers' subdisplay to /proc/timer_list, v2.
> 
> Can you add the documentation for this new field to Documentation/ABI/
> as you are changing/adding a public API.


OK.

Right now there is no ABI documention for anything in
/proc/timer_list.  Do you prefer one file for everything
in /proc/timer_list, or a seperate file for each of the
subsections?

I was also thinking the doc(s) should go into the /testing
subsection, as the displayed revision number is < 1.0.

Joe
