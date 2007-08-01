Return-Path: <linux-kernel-owner+w=401wt.eu-S1762709AbXHABzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762709AbXHABzQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 21:55:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753209AbXHABzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 21:55:04 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:51320 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757714AbXHABzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 21:55:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ep3iV/WiFgYxZpW94kpWySDb08Rq0DdN0nHlre+nvRq8eaPJXa53dcoPAC9y6mbX7UBCH6Nc7ME+MMJdS0RBwMdqrqVWPH/5UCjdKz5l40wK4Z+Jo8zdK5Jlbp0WvFEs96BjHVaty3MAdSsujkhsnhJqOjrNTPUqF9xivJvuo+c=
Subject: Re: [PATCH] retrieve VBE EDID/DDC info independent of used video
	mode
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Daniel Drake <dsd@gentoo.org>
Cc: Zwane Mwaikambo <zwane@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jan Beulich <jbeulich@novell.com>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>
In-Reply-To: <46AFDF3A.6080300@gentoo.org>
References: <4678191D.76E4.0078.0@novell.com> <4686D85B.6090803@gentoo.org>
	 <20070630154230.4ad373fa.akpm@linux-foundation.org>
	 <4690E65B.5050607@gentoo.org>
	 <20070708111404.1486e73c.akpm@linux-foundation.org>
	 <46912E09.2070806@zytor.com> <4692BC61.9070500@gentoo.org>
	 <4692BDEE.8020802@zytor.com> <4693BF02.2050705@gentoo.org>
	 <4693C0A1.8010901@zytor.com> <4693CAFF.4000609@gentoo.org>
	 <4693CCC6.7050400@zytor.com> <46AFCCBB.70307@gentoo.org>
	 <Pine.LNX.4.64.0707311719540.5207@montezuma.windriver.com>
	 <46AFDF3A.6080300@gentoo.org>
Content-Type: text/plain
Date: Wed, 01 Aug 2007 09:54:51 +0800
Message-Id: <1185933291.4688.11.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-31 at 21:17 -0400, Daniel Drake wrote:
> Zwane Mwaikambo wrote:
> > Sorry if this has been hashed out before, but could you point me towards 
> > the gentoo bugzilla entry? I'm trying to understand how your setup broke. 
> > Which version VBE does your system have?
> 
> Here's the bug:
> http://bugs.gentoo.org/show_bug.cgi?id=181067
> 

Looking at the dmesg output of the working and failing kernel, it does
seem that there's no EDID block available in the failing kernel.

> How can we identify the VBE version?

If vesafb works, then it is at least VBE 2.0. To confirm, you can use X
+ the 'vesa' driver and check /var/log/X*.log. 

Tony


