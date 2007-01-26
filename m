Return-Path: <linux-kernel-owner+w=401wt.eu-S1161216AbXAZTdy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161216AbXAZTdy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 14:33:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161218AbXAZTdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 14:33:54 -0500
Received: from smtp02.lnh.mail.rcn.net ([207.172.157.102]:8589 "EHLO
	smtp02.lnh.mail.rcn.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161216AbXAZTdx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 14:33:53 -0500
X-IronPort-AV: i="4.13,244,1167627600"; 
   d="scan'208"; a="397848211:sNHT1024279596"
From: "Matthew Kirk" <mkirk01@rcn.com>
To: "'Andrew Morton'" <akpm@osdl.org>
Cc: <linux-kernel@vger.kernel.org>
References: <001a01c74136$0028ecf0$6600a8c0@charm> <20070126031654.a41fe374.akpm@osdl.org>
Subject: RE: fsync occasionally very slow
Date: Fri, 26 Jan 2007 14:33:36 -0500
Message-ID: <000c01c74180$dfe71070$6600a8c0@charm>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="windows-1250"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
Thread-Index: AcdBO4JmoSoJJ6VJQD2VrzXdKeDUzQARLB/Q
In-Reply-To: <20070126031654.a41fe374.akpm@osdl.org>
X-Junkmail-Status: score=10/50, host=mr08.lnh.mail.rcn.net
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A09020B.45BA579E.00B4,ss=1,fgs=0,
	ip=207.172.4.11,
	so=2006-05-09 23:27:51,
	dmn=5.2.125/2006-10-10
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, this will show my ignorance...  my system is lacking
/proc/sysrq-trigger.  I can find how to build a kernel with the magic sysrq
key (CONFIG_MAGIC_SYSRQ=y), and have done so, but I still don't have
/proc/sysrq-* and cannot seem to find how to build in sysrq functionality
itself - assuming that's what's missing.  Presumably it's something in
.config I'm just not seeing?

Thanks again!

Matt

-----Original Message-----
From: Andrew Morton [mailto:akpm@osdl.org] 
Sent: Friday, January 26, 2007 6:17 AM
To: Matthew Kirk
Cc: linux-kernel@vger.kernel.org
Subject: Re: fsync occasionally very slow

On Fri, 26 Jan 2007 05:37:38 -0500
"Matthew Kirk" <mkirk01@rcn.com> wrote:

> I am working on an application that fsync(2) files and directories as
> needed.    I’m seeing intermittent stalls on fsync that can last many
> seconds.

Please generate an all-task backtrace during the stall via:

dmesg -n 8
<wait for a stall>
echo t > /prov/sysrq-trigger
dmesg -s 1000000 > foo

and send foo.

-- 
No virus found in this incoming message.
Checked by AVG Free Edition.
Version: 7.1.410 / Virus Database: 268.17.11/652 - Release Date: 1/25/2007
 

-- 
No virus found in this outgoing message.
Checked by AVG Free Edition.
Version: 7.1.410 / Virus Database: 268.17.12/653 - Release Date: 1/26/2007
 
