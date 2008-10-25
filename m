Return-Path: <linux-kernel-owner+w=401wt.eu-S1752900AbYJYOAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900AbYJYOAh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 10:00:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751913AbYJYOA3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 10:00:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:55545 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798AbYJYOA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 10:00:29 -0400
Date: Sat, 25 Oct 2008 07:00:43 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       Matt Mackall <mpm@selenic.com>
Subject: Re: [pull request] getting rid of __cpuinit
Message-ID: <20081025070043.50578543@infradead.org>
In-Reply-To: <20081025075925.GA22805@uranus.ravnborg.org>
References: <20081024142056.6a2d082a@infradead.org>
	<20081025075925.GA22805@uranus.ravnborg.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Oct 2008 09:59:25 +0200
Sam Ravnborg <sam@ravnborg.org> wrote:

> >    text	   data	    bss	    dec
> > hex	filename 4618096	1358684	 848588
> > 6825368	 682598	vmlinux.before 4619965
> > 1356908	 848716	6825589  682675	vmlinux.after
> 
> The interesting number here is the size of the cpuinit/cpuexit
> sections. cpuinit sections are discarded after init and cpuexit
> sections are discarded if you do not use modules.
> 
> Can you share these numbers with us?

those sections don't actually exist because of the linker script 
magic...


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
