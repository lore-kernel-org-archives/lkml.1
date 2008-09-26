Return-Path: <linux-kernel-owner+w=401wt.eu-S1754264AbYIZCtr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264AbYIZCtr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 22:49:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753090AbYIZCtj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 22:49:39 -0400
Received: from qmta10.westchester.pa.mail.comcast.net ([76.96.62.17]:42593
	"EHLO QMTA10.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753031AbYIZCtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 22:49:39 -0400
X-Authority-Analysis: v=1.0 c=1 a=x17pv2GxPoAA:10 a=db7HBzCpc8oA:10
 a=ZKCgBMgPiHFEo6gdk6kA:9 a=7_stDjvB73Tb_fJR_jgeEngBQwYA:4 a=nbrB6oW77rQA:10
Date: Thu, 25 Sep 2008 21:49:27 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: CONFIG_SECURITY_ROOTPLUG [was: Re: 2.6.27-rc7 no init found on the root partition?]
Message-ID: <20080926024927.GA13816@hallyn.com>
References: <20080925165400.GQ31582@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080925165400.GQ31582@ics.muni.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Lukas Hejtmanek (xhejtman@ics.muni.cz):
> Hello,
> 
> I finally found my problems with no init found.
> 
> It was caused by the CONFIG_SECURITY_ROOTPLUG option.
> 
> I wonder why this option in 2.6.26.3 kernel allows the kernel boot up, while
> with 2.6.27-rc7, the kernel is unable to run even init.

Hmm, is there a difference in the device drivers such that root_plug simply
isn't able to find the usb 'key' in 2.6.27-rc7?

When you boot with CONFIG_SECURITY_ROOTPLUG=n, can you read the usb key?

-serge
