Return-Path: <linux-kernel-owner+w=401wt.eu-S1756327AbYA2JEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756327AbYA2JEk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 04:04:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752582AbYA2JE0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 04:04:26 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:57009 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784AbYA2JEY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 04:04:24 -0500
Subject: Re: [PATCH] documentation: Add desc of new cpu fields in /proc/stat
From: Laurent Vivier <Laurent.Vivier@bull.net>
To: AP <ap@zip.com.au>
Cc: linux-kernel@vger.kernel.org, avi@qumranet.com, mingo@elte.hu
In-Reply-To: <20080129084352.GA4221@zip.com.au>
References: <20080129084352.GA4221@zip.com.au>
Organization: Bull S.A.S.
Date: Tue, 29 Jan 2008 10:05:16 +0100
Message-Id: <1201597516.4309.4.camel@frecb07144>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 29/01/2008 10:13:01,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 29/01/2008 10:13:03,
	Serialize complete at 29/01/2008 10:13:03
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

good thing, but could you update too "Table 1-3: Contents of the stat
files" with fields added by 9ac52315d4cf5f561f36dabaf0720c00d3553162 .

Thank you,
Laurent

On mar, 2008-01-29 at 19:43 +1100, AP wrote:
> Today I noticed that a new field cropped up in /proc/stat. The git patch
> that made it is 5e84cfde51cf303d368fcb48f22059f37b3872de. I hope the
> following description is adequately accurate. I tried to keep it short.
> 
> Signed-Off-By: Andrew P <ap@zip.com.au>
> 
> diff -aur linux/Documentation/filesystems/proc.txt work/Documentation/filesystems/proc.txt
> --- linux/Documentation/filesystems/proc.txt	2008-01-29 11:27:18.000000000 +1100
> +++ work/Documentation/filesystems/proc.txt	2008-01-29 11:37:41.000000000 +1100
> @@ -813,9 +813,9 @@
>  since the system first booted.  For a quick look, simply cat the file:
>  
>    > cat /proc/stat
> -  cpu  2255 34 2290 22625563 6290 127 456 0
> -  cpu0 1132 34 1441 11311718 3675 127 438 0
> -  cpu1 1123 0 849 11313845 2614 0 18 0
> +  cpu  2255 34 2290 22625563 6290 127 456 0 0
> +  cpu0 1132 34 1441 11311718 3675 127 438 0 0
> +  cpu1 1123 0 849 11313845 2614 0 18 0 0
>    intr 114930548 113199788 3 0 5 263 0 4 [... lots more numbers ...]
>    ctxt 1990473
>    btime 1062191376
> @@ -836,6 +836,7 @@
>  - irq: servicing interrupts
>  - softirq: servicing softirqs
>  - steal: involuntary wait
> +- guest: time used to run a virtual CPU
>  
>  The "intr" line gives counts of interrupts  serviced since boot time, for each
>  of the  possible system interrupts.   The first  column  is the  total of  all
> 
-- 
----------------- Laurent.Vivier@bull.net  ------------------
  "La perfection est atteinte non quand il ne reste rien à
ajouter mais quand il ne reste rien à enlever." Saint Exupéry

