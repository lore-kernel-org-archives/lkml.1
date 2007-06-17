Return-Path: <linux-kernel-owner+w=401wt.eu-S1758169AbXFQBYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758169AbXFQBYW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 21:24:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752103AbXFQBYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 21:24:13 -0400
Received: from rwcrmhc13.comcast.net ([216.148.227.153]:56881 "EHLO
	rwcrmhc13.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562AbXFQBYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 21:24:12 -0400
Message-ID: <46749EF6.6060306@wolfmountaingroup.com>
Date: Sat, 16 Jun 2007 20:39:50 -0600
From: "Jeffrey V. Merkey" <jmerkey@wolfmountaingroup.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.8) Gecko/20050513 Fedora/1.7.8-2
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: "Jeffrey V. Merkey" <jmerkey@wolfmountaingroup.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jan Harkes <jaharkes@cs.cmu.edu>,
       Jack Stone <jack@hawkeye.stone.uk.eu.org>, alan <alan@clueserver.org>,
       hpa@zytor.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       viro@zeniv.linux.org.uk
Subject: Re: Versioning file system
References: <46731169.2090002@hawkeye.stone.uk.eu.org>	<467314E2.9010306@zytor.com>	<Pine.LNX.4.64.0706151547200.27993@blackbox.fnordora.org>	<46739B2C.4080606@hawkeye.stone.uk.eu.org>	<4673B15B.2080300@wolfmountaingroup.com>	<4673B77E.1000803@wolfmountaingroup.com>	<20070616164931.GF14788@delft.aura.cs.cmu.edu>	<46744225.7000609@wolfmountaingroup.com>	<20070616203926.GG14788@delft.aura.cs.cmu.edu> <20070616231758.7bbe9d01@the-village.bc.nu> <467499FF.5060306@wolfmountaingroup.com>
In-Reply-To: <467499FF.5060306@wolfmountaingroup.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeffrey V. Merkey wrote:

> The trick in the NetWare 3 model was to segregate the directory 
> entries onto special reserved
> 4K directory blocks (128 byte dir records). When it came time to purge 
> storage after the file system filled, an entire 4K block and all
> chains was deleted during block allocation for new files. The dir 
> blocks were ordered by date -- oldest ones got purged
> first. The model worked very well until compression was added to the 
> filesystem, then it started getting complex.
>
> I would be willing to help instrument the NetWare 3 model in this 
> proposal on ext3, since this is a basic versioning model and
> would provide coverage for 99% of the folks needing this capability. I 
> am available for questions.
>
> Jeff
>
I resigned as Chief Scientist of Solera Networks May 8 this year -- 
mostly because I was not allowed to have any freedom, including working on
free Linux projects. This went on for almost 4 years (since 2003). Now 
that I am independent again, I can work on stuff like this again. I 
started a new company with John Noorda (Ray Noorda's oldest son) who 
runs Canopy now. That's my current status. I am an owner and entrepeneur 
again. So I have a lot of free time and will from now on.

Jeff
