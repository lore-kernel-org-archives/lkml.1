Return-Path: <linux-kernel-owner+w=401wt.eu-S1753170AbXDLTkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170AbXDLTkg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 15:40:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753122AbXDLTkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 15:40:36 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:48225 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753170AbXDLTkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 15:40:35 -0400
X-Greylist: delayed 3059 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Apr 2007 15:40:35 EDT
Date: Thu, 12 Apr 2007 20:46:55 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Egmont Koblinger <egmont@uhulinux.hu>
cc: "H. Peter Anvin" <hpa@zytor.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] console UTF-8 fixes
In-Reply-To: <20070412165540.GB21576@uhulinux.hu>
Message-ID: <Pine.LNX.4.61.0704122042480.14441@yvahk01.tjqt.qr>
References: <4617DBF7.5060009@zytor.com> <20070410094325.GB9143@uhulinux.hu>
 <461BB092.3070201@zytor.com> <20070410171924.GA18314@uhulinux.hu>
 <20070410183659.7341eeec@the-village.bc.nu> <20070411182801.GC26382@uhulinux.hu>
 <461D2AB8.5080902@zytor.com> <20070412091120.GA15666@uhulinux.hu>
 <461E5212.8070807@zytor.com> <Pine.LNX.4.61.0704121840350.14441@yvahk01.tjqt.qr>
 <20070412165540.GB21576@uhulinux.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 12 2007 18:55, Egmont Koblinger wrote:
>
>> >> I've been thinking on it and I'm not sure which one the right
>> >> way is. The reason for choosing this was probably that this way
>> >> information that is not used by the code can be omitted by the
>> >> compiler.
>> >
>> > Then let's leave it out of the source.
>> 
>> I however will put this into my rpm if it works/isstable.
>
>We've arrived at another coding policy :)
>
>There are two possible behaviors, each have pros and cons. HPA
>prefers one, while Jan and me would prefer the other.

I don't really care how it's done - however it should at least not
hurt in the eyes (<->CodingStyle). I just welcome this
functionality/bugfix, because I find myself editing text with
undisplayable characters more often than not. Should be ok now.


Jan
-- 
