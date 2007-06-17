Return-Path: <linux-kernel-owner+w=401wt.eu-S1758749AbXFQBDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758749AbXFQBDT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 21:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757784AbXFQBDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 21:03:10 -0400
Received: from rwcrmhc14.comcast.net ([204.127.192.84]:46382 "EHLO
	rwcrmhc14.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757758AbXFQBDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 21:03:08 -0400
Message-ID: <467499FF.5060306@wolfmountaingroup.com>
Date: Sat, 16 Jun 2007 20:18:39 -0600
From: "Jeffrey V. Merkey" <jmerkey@wolfmountaingroup.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.8) Gecko/20050513 Fedora/1.7.8-2
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Jan Harkes <jaharkes@cs.cmu.edu>,
       Jack Stone <jack@hawkeye.stone.uk.eu.org>, alan <alan@clueserver.org>,
       hpa@zytor.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       viro@zeniv.linux.org.uk
Subject: Re: Versioning file system
References: <46731169.2090002@hawkeye.stone.uk.eu.org>	<467314E2.9010306@zytor.com>	<Pine.LNX.4.64.0706151547200.27993@blackbox.fnordora.org>	<46739B2C.4080606@hawkeye.stone.uk.eu.org>	<4673B15B.2080300@wolfmountaingroup.com>	<4673B77E.1000803@wolfmountaingroup.com>	<20070616164931.GF14788@delft.aura.cs.cmu.edu>	<46744225.7000609@wolfmountaingroup.com>	<20070616203926.GG14788@delft.aura.cs.cmu.edu> <20070616231758.7bbe9d01@the-village.bc.nu>
In-Reply-To: <20070616231758.7bbe9d01@the-village.bc.nu>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:

>>  (Vax/VMS System Software Handbook)
>>  (TOPS-20 User's Manual)
>>    
>>
>
>Also Files/11
>
>Basic versioning goes back to at least ITS
>
>Not sure how old doing file versioning and hiding it away with a tool to
>go rescue the stuff you blew away by mistake is, but Novell Netware 3
>certainly did a good job on that one
>  
>

The trick in the NetWare 3 model was to segregate the directory entries 
onto special reserved
4K directory blocks (128 byte dir records). When it came time to purge 
storage after the file system filled, an entire 4K block and all
chains was deleted during block allocation for new files. The dir blocks 
were ordered by date -- oldest ones got purged
first. The model worked very well until compression was added to the 
filesystem, then it started getting complex.

I would be willing to help instrument the NetWare 3 model in this 
proposal on ext3, since this is a basic versioning model and
would provide coverage for 99% of the folks needing this capability. I 
am available for questions.

Jeff

>-
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
>
>  
>

