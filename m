Return-Path: <linux-kernel-owner+w=401wt.eu-S1755382AbXH0DmK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382AbXH0DmK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 23:42:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754029AbXH0Dl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 23:41:59 -0400
Received: from smtpout.mac.com ([17.250.248.186]:50901 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752743AbXH0Dl6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 23:41:58 -0400
In-Reply-To: <4877c76c0708260520v33bc36bfu24e688a5902912e5@mail.gmail.com>
References: <200708222058.45480.mjevans1983@comcast.net> <18126.21113.981032.286298@notabene.brown> <200708260451.24868.mjevans1983@comcast.net> <4877c76c0708260520v33bc36bfu24e688a5902912e5@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <ADB93FAB-45EF-439A-816C-8E27D8D3F5BB@mac.com>
Cc: "Michael J. Evans" <mjevans1983@comcast.net>, Neil Brown <neilb@suse.de>,
       Ingo Molnar <mingo@redhat.com>, linux-raid@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [patch v2 1/1] md: Software Raid autodetect dev list not array
Date: Sun, 26 Aug 2007 23:41:29 -0400
To: Michael Evans <mjevans1983@gmail.com>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Aug 26, 2007, at 08:20:45, Michael Evans wrote:
> Also, I forgot to mention, the reason I added the counters was  
> mostly for debugging.  However they're also as useful in the same  
> way that listing the partitions when a new disk is added can be (in  
> fact this augments that and the existing messages the autodetect  
> routines provide).
>
> As for using autodetect or not... the only way to skip it seems to  
> be compiling md's raid support as a module.  I checked 2.6.22's  
> menuconfig and there's no way for me to explicitly turn it on or  
> off at compile time.  I also feel that forcing the addition of a  
> boot parameter to de-activate a broken and deprecated system you  
> aren't even aware you are getting is somehow wrong.  So if you have  
> over 128 devices for it to scan, as I do on one of my PCs, then it  
> can bring up
> an array in degraded mode.  ... crud.

Well, you could just change the MSDOS disk label to use a different  
"Partition Type" for your raid partitions.  Just pick the standard  
"Linux" type and you will get exactly the same behavior that  
everybody who doesn't use MSDOS partition tables gets.

Cheers,
Kyle Moffett

