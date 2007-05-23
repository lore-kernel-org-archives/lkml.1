Return-Path: <linux-kernel-owner+w=401wt.eu-S1760231AbXEWJ6F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760231AbXEWJ6F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 05:58:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757444AbXEWJ5z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 05:57:55 -0400
Received: from nz-out-0506.google.com ([64.233.162.229]:52581 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755631AbXEWJ5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 05:57:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=E0VkC7bJDabgGLYHkTGoyBJkmTde3Trw3NVBiAMetg9QMDb3ZwW3b2HXnO3/0o7uetykeqop0ygRHVWaXfK68Mv5I6kdy7ZWn0nt7nI4RwGucdzlsliLrjkKN7cn+yynK7k+fVnbWzLC4puZbKIMTVsIDmwpPDn9OM76RISfFA0=
Subject: Re: 2.6.21.1 fails to suspend/resume  to disk  (sort of)
From: Romano Giannetti <romano.giannetti@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
In-Reply-To: <200705231105.08408.rjw@sisk.pl>
References: <1179905115.7043.25.camel@localhost>
	 <200705231105.08408.rjw@sisk.pl>
Content-Type: text/plain
Date: Wed, 23 May 2007 11:57:42 +0200
Message-Id: <1179914262.7043.56.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-23 at 11:05 +0200, Rafael J. Wysocki wrote:
> Hi,
> 
> On Wednesday, 23 May 2007 09:25, Romano Giannetti wrote:
> > http://lkml.org/lkml/2007/5/23/38
> 
> Please see http://bugzilla.kernel.org/show_bug.cgi?id=8456
> That seems to resemble the symptoms you describe.
> 

No, I don't think. The delay I observe is on resume (suspend is very
fast). Moreover, I have no SATA. It seems that my problem came from
pcmcia.

> > Now for the suspend to disk. With default setting (/sys/power/disk ==
> > platform) my laptop (vaio PGC-FX701) fails to poweroff; it stays with
> > backlight on, a white screen, and if I power it off manually afterward
> > it did not resume.
> > 
> > By doing echo shutdown > /sys/power/disk the laptop *do* power off (it's
> > very slow, but I think that's related with the 60 secs delay commented
> > in the other post). Then it resume --- text console did resume ok ---
> > but the virtual console with X do not come back. I had to do a
> > ctrl-alt-backspace thing. 
> > 
> > Any hints? More data?
> 
> Could you please test the 2.6.22-rc2 kernel?  Also, if it still doesn't work
> properly, could you apply the hibernation/suspend patchset available from
> http://www.sisk.pl/kernel/hibernation_and_suspend/2.6.22-rc2/patches
> on top of it and see if that helps?
> 

Uf, I will try to find the time. I am on my way to try to compile
2.6.21.2 now. Problem is that a kernel compile "the ubuntu way" last
hours here. If there is an expert on make-kpkg here, I could use some
advise. I'd prefer to test patches over a 2.6.21 stable release, to
avoid mixing symptoms from an experimental -rc...

Romano



