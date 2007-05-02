Return-Path: <linux-kernel-owner+w=401wt.eu-S2992626AbXEBAsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992626AbXEBAsl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 20:48:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992589AbXEBAsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 20:48:41 -0400
Received: from smtpout06-04.prod.mesa1.secureserver.net ([64.202.165.227]:59632
	"HELO smtpout06.prod.mesa1.secureserver.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S2992587AbXEBAsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 20:48:37 -0400
Message-ID: <4637DFE2.5020706@seclark.us>
Date: Tue, 01 May 2007 20:48:34 -0400
From: Stephen Clark <Stephen.Clark@seclark.us>
Reply-To: Stephen.Clark@seclark.us
User-Agent: Mozilla/5.0 (X11; U; Linux 2.2.16-22smp i686; en-US; m18) Gecko/20010110 Netscape6/6.5
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Chuck Ebbert <cebbert@redhat.com>
CC: Jesse Barnes <jesse.barnes@intel.com>, Jeff Garzik <jeff@garzik.org>,
       linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata updates
References: <20070429161542.GA12501@havoc.gtf.org> <46364C04.4050208@garzik.org> <46364FFA.9050500@seclark.us> <200705011438.07499.jesse.barnes@intel.com> <4637C30C.5000109@seclark.us> <4637C3F4.5030800@redhat.com>
In-Reply-To: <4637C3F4.5030800@redhat.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck Ebbert wrote:

>Stephen Clark wrote:
>  
>
>>I'm running fc6 but with kernel 2.6.21 from kernel.org - compiled with
>>the .config file from fc6.
>>
>>My system is a asus laptop with an ich7 chipset which has both sata and
>>pata controllers. My
>>laptop only brings out the pata controller interface and both my hd and
>>od are on the second
>>channel of the pata.
>>
>>So can I configure out the old ide and just have ata_piix automatically
>>control them both in
>>2.6.21?
>>
>>    
>>
>
>Sure, just edit the .config. You may need to play with options to mkinitrd
>though; I don't think it will include the PATA drivers for you automatically.
>
>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
>
>  
>
It worked - no combined_mode=libata and my hd is doing 45mb/sec.
Thanks to all who replied.

Steve

-- 

"They that give up essential liberty to obtain temporary safety, 
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty 
decreases."  (Thomas Jefferson)



