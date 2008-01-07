Return-Path: <linux-kernel-owner+w=401wt.eu-S1755715AbYAGJoI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755715AbYAGJoI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 04:44:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754418AbYAGJn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 04:43:56 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:56970 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754182AbYAGJnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 04:43:55 -0500
Date: Mon, 7 Jan 2008 07:43:37 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Douglas Landgraf <dougsland@gmail.com>, Gregor Jasny <jasny@vidsoft.de>,
       linux-kernel@vger.kernel.org,
       video4linux-list <video4linux-list@redhat.com>,
       v4l-dvb-maintainer@linuxtv.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [v4l-dvb-maintainer] [PATCH] Re: Regression: VIDIOCGMBUF ioctl
 hangs on bttv driver (2.6.24-rc6)
Message-ID: <20080107074337.1aabcf07@gaivota>
In-Reply-To: <20080106232234.GA12783@elte.hu>
References: <20080105223338.GA18690@vidsoft.de>
	<20080106141548.GB18690@vidsoft.de>
	<68cac7520801061453w6906e510o5d53449e0b28f400@mail.gmail.com>
	<20080106232234.GA12783@elte.hu>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.1; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Jan 2008 00:22:34 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Douglas Landgraf <dougsland@gmail.com> wrote:
> 
> > Hi guys,
> > 
> >     Gregor, we have converted bttv driver to use vidioc_ioctl2 some 
> > days ago. Could you check and create your patch against v4l 
> > development tree? Bttv driver does not have anymore bttv_do_ioctl().
> 
> this is about the bttv driver in 2.6.24-rc6/(rc7?) hanging. So whatever 
> the devel tree does, this fix (if it's a correct fix) needs to be 
> commited upstream ASAP.

For sure. I've just sent Linus a pull request for the fix.

On the devel tree, all this code got removed, replaced by a simple function
call at videobuf. So, I don't expect similar issues for 2.6.25.

I've already fixed the patch conflicts at devel branch for v4l/dvb -git tree.

Cheers,
Mauro
