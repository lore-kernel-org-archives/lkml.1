Return-Path: <linux-kernel-owner+w=401wt.eu-S1757884AbXEaPqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757884AbXEaPqi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 11:46:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753081AbXEaPqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 11:46:31 -0400
Received: from smtpout05-04.prod.mesa1.secureserver.net ([64.202.165.221]:44233
	"HELO smtpout05.prod.mesa1.secureserver.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1753054AbXEaPqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 11:46:31 -0400
Message-ID: <465EEDD3.4070100@seclark.us>
Date: Thu, 31 May 2007 11:46:27 -0400
From: Stephen Clark <Stephen.Clark@seclark.us>
Reply-To: Stephen.Clark@seclark.us
User-Agent: Mozilla/5.0 (X11; U; Linux 2.2.16-22smp i686; en-US; m18) Gecko/20010110 Netscape6/6.5
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Frank Sorenson <frank@tuxrocks.com>
CC: LKML <linux-kernel@vger.kernel.org>, jeff@garzik.org
Subject: Re: Combined mode quirk removal kills performance
References: <465EDF89.9050207@tuxrocks.com>
In-Reply-To: <465EDF89.9050207@tuxrocks.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Frank Sorenson wrote:

>-----BEGIN PGP SIGNED MESSAGE-----
>Hash: SHA1
>
>The patch to "remove combined mode quirk" (git bisect says
>8cdfb29c0cd8018f92214c11c631d8926f4cb032) makes my laptop run slower
>than a dead sloth.  "hdparm -T" indicates that buffered disk reads on my
>hard drive drop from 48-50 MB/sec to 1-2MB/sec, and the system is nearly
>unusable.
>
>System is a Dell Inspiron E1705 (Core 2 Duo 2.16GHz) running x86_64 FC6.
>
>Frank
>- --
>Frank Sorenson - KD7TZK
>Linux Systems Engineer, DSS Engineering, UBS AG
>frank@tuxrocks.com
>-----BEGIN PGP SIGNATURE-----
>Version: GnuPG v1.4.7 (GNU/Linux)
>Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org
>
>iD8DBQFGXt+JaI0dwg4A47wRAqJmAJ4k4E9ekkitOdQ72HUXbky11nD1cACghGu6
>y7Y71PPaKHYcQhYSfL55bNk=
>=MPYY
>-----END PGP SIGNATURE-----
>-
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
>
>  
>
Hi Frank,

I had the same problem. I am running FC6 and had to build a custom 
kernel that did not configure
in the old ide driver - then my speed of my harddrive went back to normal.

HTH,
Steve

-- 

"They that give up essential liberty to obtain temporary safety, 
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty 
decreases."  (Thomas Jefferson)



