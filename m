Return-Path: <linux-kernel-owner+w=401wt.eu-S1764096AbYBVLoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764096AbYBVLoA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 06:44:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756728AbYBVLnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 06:43:49 -0500
Received: from www.tglx.de ([62.245.132.106]:46151 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756455AbYBVLns (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 06:43:48 -0500
Date: Fri, 22 Feb 2008 12:43:00 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: David Woodhouse <dwmw2@infradead.org>
cc: Quel Qun <kelk1@comcast.net>, Dave Young <hidave.darkstar@gmail.com>,
       Marcel Holtmann <marcel@holtmann.org>,
       LKML <linux-kernel@vger.kernel.org>, Jiri Kosina <jkosina@suse.cz>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Kernel oops with bluetooth usb dongle
In-Reply-To: <1203680049.5771.44.camel@shinybook.infradead.org>
Message-ID: <alpine.LFD.1.00.0802221242400.7583@apollo.tec.linutronix.de>
References: <022220080240.25836.47BE362900072A1C000064EC2200761394CE05040A05@comcast.net>  <alpine.LFD.1.00.0802220813180.7583@apollo.tec.linutronix.de> <1203680049.5771.44.camel@shinybook.infradead.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Feb 2008, David Woodhouse wrote:
 
> On Fri, 2008-02-22 at 08:23 +0100, Thomas Gleixner wrote:
> > 
> > +       del_timer(&conn->info_timer);
> > +
> >         hcon->l2cap_data = NULL;
> >         kfree(conn);
> 
> Shouldn't that be del_timer_sync() ?

Hmm, probably yes.

     tglx
