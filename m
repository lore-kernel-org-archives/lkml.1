Return-Path: <linux-kernel-owner+w=401wt.eu-S1761991AbXEPBjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761991AbXEPBjz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 21:39:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760886AbXEPBjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 21:39:48 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:33609 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759688AbXEPBjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 21:39:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fo88EYhQrKCxxU+as1X1C4QSV7XPp9cOMtZW10qaVA3vCP+e5XK5DP/COaHJ40xmquwKnVIReap0AHFHWFc06cWjyhXfXAcM5yAE11hmajnZ/nI1z1jcYs91pltA6Xj8dsO3KmRIzTaC6vwqijr4LJfHAV4lUt9PSsAQ+nwgpKg=
Message-ID: <a781481a0705151839l65ea7ee0yb61bf7c911a0c2f8@mail.gmail.com>
Date: Wed, 16 May 2007 07:09:46 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Tilman Schmidt" <tilman@imap.cc>
Subject: Re: Linux 2.6.22-rc1
Cc: "Jan Engelhardt" <jengelh@linux01.gwdg.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "Stefan Richter" <stefanr@s5r6.in-berlin.de>
In-Reply-To: <46498EE3.8010907@imap.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.0.98.0705121857100.6739@woody.linux-foundation.org>
	 <4647569D.7010709@imap.cc>
	 <Pine.LNX.4.61.0705141918180.9570@yvahk01.tjqt.qr>
	 <4648A3DF.7040004@imap.cc>
	 <Pine.LNX.4.61.0705142227350.9570@yvahk01.tjqt.qr>
	 <a781481a0705141934u6b369dd5ob1715f14890af914@mail.gmail.com>
	 <46498EE3.8010907@imap.cc>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/15/07, Tilman Schmidt <tilman@imap.cc> wrote:
> [...]
> > I do agree that anything non-essential (even if it's just a presentation
> > menu that doesn't affect builds) must be default n.
>
> It's tricky for "make oldconfig" when introducing a new "menuconfig"
> around some previously existing "config"s, because just accepting
> the default for the new option then causes previously selected
> ones to be silently dropped. But I don't know a perfect solution
> for that. Perhaps we'll just have to live with it. Or perhaps a
> warning message along the line of "deselecting option xxx" would
> be in order.
> [...]
> It's actually the other way around, all those options now tucked
> underneath the menuconfig were previously directly visible, so
> selecting "y" (either explicitly or by default) makes everything
> work as before while "n" very conveniently skips them all.

Jan did mention this in the previous thread, but as Jens said,
these problems would occur only the _first_ time someone
transitions from the old .config's to the new scheme. But those
"default y"s for all the various "configmenu"s (let's please call
them that) that got introduced in the Kconfig files would cause
unnecessary annoyance to users of make oldconfig _for ever_.
