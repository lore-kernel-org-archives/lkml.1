Return-Path: <linux-kernel-owner+w=401wt.eu-S932463AbXHXMz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932463AbXHXMz3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 08:55:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765811AbXHXMyp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 08:54:45 -0400
Received: from attila.bofh.it ([213.92.8.2]:54304 "EHLO attila.bofh.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765124AbXHXMyk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 08:54:40 -0400
X-Greylist: delayed 1747 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Aug 2007 08:54:40 EDT
Date: Fri, 24 Aug 2007 13:56:29 +0200
To: Meelis Roos <mroos@linux.ee>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: isapnp & module autoload (udev?)
Message-ID: <20070824115629.GA6417@bongo.bofh.it>
References: <Pine.SOC.4.64.0708241434440.27738@math.ut.ee>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.SOC.4.64.0708241434440.27738@math.ut.ee>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: md@Linux.IT (Marco d'Itri)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Aug 24, Meelis Roos <mroos@linux.ee> wrote:

> I tested 2.6.23-rc3 along with Debian unstable on a older pentium2-era 
> PC that has a ISA bus sound card that isapnp finds. snd-sb finds it too 
> using isapnp. However, there seems to be no module autoloading 
> happening.
> 
> So, the question is: should isapnp moudle autoloading work with current 
> kernel + current udev?
Only for some devices, others do not provide in sysfs everything needed
to build the MODALIAS string.

-- 
ciao,
Marco
