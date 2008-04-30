Return-Path: <linux-kernel-owner+w=401wt.eu-S932998AbYD3U3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932998AbYD3U3c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 16:29:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756738AbYD3U3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 16:29:22 -0400
Received: from mx0.towertech.it ([213.215.222.73]:48448 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756377AbYD3U3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 16:29:20 -0400
Date: Wed, 30 Apr 2008 22:29:14 +0200
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: David Woodhouse <dwmw2@infradead.org>
Cc: rtc-linux@googlegroups.com, paulus@samba.org, linux-kernel@vger.kernel.org
Subject: Re: [rtc-linux] Re: [PATCH] RTC class driver for ppc_md RTC
 functions
Message-ID: <20080430222914.4e1dd640@i1501.lan.towertech.it>
In-Reply-To: <1209576873.25560.398.camel@pmac.infradead.org>
References: <18449.48370.434716.293552@cargo.ozlabs.ibm.com>
	<20080428102629.6e702137@i1501.lan.towertech.it>
	<1209371478.25560.114.camel@pmac.infradead.org>
	<20080428105245.5c9fff85@i1501.lan.towertech.it>
	<1209378191.25560.121.camel@pmac.infradead.org>
	<20080428124033.70e78dcf@i1501.lan.towertech.it>
	<1209380882.25560.127.camel@pmac.infradead.org>
	<20080430113933.14651edc@i1501.lan.towertech.it>
	<1209576873.25560.398.camel@pmac.infradead.org>
Organization: Tower Technologies
X-Mailer: Sylpheed
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Apr 2008 18:34:33 +0100
David Woodhouse <dwmw2@infradead.org> wrote:

> > 
> >  If we are talking about milliseconds I think a suspect is not enough.
> 
> Let me rephrase: This is how we're doing it for _every_ machine/platform
> which supports update_persistent_clock(). It makes sense to let
> individual RTC-class drivers do it differently if they need to, but it's
> a damn good default behaviour until/unless someone actually shows that
> they need it to be different. :)

 I still do not think that it makes sense to keep an unreliable hw RTC in
 sync with the system clock.. 

 I remember somone wrote a kind of ntp subsytem for the kernel but can't
 remember who :(
 
> >  My opinion is that such NTP mode could be removed from the kernel/not
> >  implemented in rtc class without loosing anything.
> 
> Want to send a patch to lkml which removes update_persistent_clock() and
> see what people think of that? :)

 I'm not _that_ mad, unless the patch is signed by Linus :)

 Anyway I will gladly accept a patch that implements this ntp mode :)

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

