Return-Path: <linux-kernel-owner+w=401wt.eu-S1757200AbZJDCZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757200AbZJDCZn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 22:25:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757179AbZJDCZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 22:25:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:36307 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933AbZJDCZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 22:25:41 -0400
Date: Sat, 3 Oct 2009 19:25:24 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Matteo Croce <technoboy85@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: i686 quirk for AMD Geode
Message-ID: <20091003192524.2ca2bd9e@infradead.org>
In-Reply-To: <40101cc30910031504pa9f8536k82dbd7668dfa643d@mail.gmail.com>
References: <40101cc30910021912r17b3a08bue1b9412e4fa47d89@mail.gmail.com>
	<20091003110546.78958508@infradead.org>
	<40101cc30910031504pa9f8536k82dbd7668dfa643d@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 Oct 2009 00:04:03 +0200
Matteo Croce <technoboy85@gmail.com> wrote:

> >
> > the number that is exposed in /proc/cpuinfo does not control
> > if cmov is used... so the patch and the benchmark are totally
> > unrelated.
> >
> 
> yes cmov and i686 are unrelated but some distros (Debian & co.)
> compiles libraries for two archs:
> i486 and i686-cmov so only i686 machines does benefit from cmov.
> This is why I cared about having an i686 aware userspace but it seems
> that for a missing instruction I can't do that

I'm surprised that "i686" in debian depends on the family flag
in /proc/cpuinfo.. but hey.. weirder things have been done.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
