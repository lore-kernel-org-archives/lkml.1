Return-Path: <linux-kernel-owner+w=401wt.eu-S1754244AbXHCEbN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244AbXHCEbN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 00:31:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751103AbXHCEbC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 00:31:02 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:57981 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750902AbXHCEbA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 00:31:00 -0400
Date: Fri, 3 Aug 2007 06:32:16 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Bryan Wu <bryan.wu@analog.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: blackfin toolchain and build issues
Message-ID: <20070803043216.GA7003@uranus.ravnborg.org>
References: <20070729223613.GA5916@martell.zuzino.mipt.ru> <alpine.LFD.0.999.0707291706490.3442@woody.linux-foundation.org> <1185770527.22473.2.camel@roc-desktop> <20070730194335.GE5776@martell.zuzino.mipt.ru> <1185850297.20043.6.camel@roc-desktop> <20070802194405.GB3646@uranus.ravnborg.org> <1186107481.6131.2.camel@roc-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1186107481.6131.2.camel@roc-laptop>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 03, 2007 at 10:18:01AM +0800, Bryan Wu wrote:
> 
> I will check this on my side ASAP.  But the git-tree did not merge my
> "fs.h" header file patch, how could it compiled passed like this?
> 
I just inserted "#include <linux/fs.h> in mm.h as a temporary workaround.
I also had to deselect a few drivers to make it build this far (used defconfig).

	Sam
