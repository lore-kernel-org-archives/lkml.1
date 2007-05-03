Return-Path: <linux-kernel-owner+w=401wt.eu-S1030973AbXECJtj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030973AbXECJtj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 05:49:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161175AbXECJtj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 05:49:39 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:48758 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030991AbXECJth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 05:49:37 -0400
X-Originating-Ip: 72.143.66.196
Date: Thu, 3 May 2007 05:49:10 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Satyam Sharma <satyam.sharma@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org
Subject: Re: finding your own dead "CONFIG_" variables
In-Reply-To: <a781481a0705030237l7d636b55t93f2ee5151cd7709@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0705030546310.29962@localhost.localdomain>
References: <Pine.LNX.4.64.0705030400120.20539@localhost.localdomain>
 <a781481a0705030237l7d636b55t93f2ee5151cd7709@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-15.989, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00, RCVD_IN_SORBS_DUL 20.00,
	SUBJ_YOUR_OWN 0.81)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 May 2007, Satyam Sharma wrote:

> > http://fsdev.net/wiki/index.php?title=Dead_CONFIG_variables
>
> > kcfiles=$(find . -name "Kconfig*")
>
> Suggest: configfiles=$(find . -name 'Kconfig*' -or -name '*defconfig*')
>
> Some CONFIG_ options exist that are not declared anywhere in the
> Kconfig files but defined directly in the arch/.../*defconfig*
> files.

it's my understanding that entries in any defconfig files are
*automatically* pruned at some point once a CONFIG_ variable no longer
exists in any Kconfig file, so i'm not going to be touching those
files.  also, adding that extra check wouldn't add anything useful to
the output.

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
