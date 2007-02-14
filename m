Return-Path: <linux-kernel-owner+w=401wt.eu-S964774AbXBNVn1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964774AbXBNVn1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 16:43:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964776AbXBNVn1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 16:43:27 -0500
Received: from mexforward.lss.emc.com ([128.222.32.20]:22632 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964774AbXBNVn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 16:43:26 -0500
X-Greylist: delayed 2050 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Feb 2007 16:43:26 EST
To: "Sorin Faibish" <sfaibish@emc.com>,
       "kernel list" <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] DualFS: File System with Meta-data and Data Separation
From: sfaibish <sfaibish@emc.com>
Organization: EMC
Cc: "piernas@ditec.um.es" <piernas@ditec.um.es>
Content-Type: text/plain; format=flowed; delsp=yes; charset=iso-8859-15
MIME-Version: 1.0
References: <op.tnkdlbgsrwwil4@brcsmondepl2c.corp.emc.com>
Content-Transfer-Encoding: 7bit
Date: Wed, 14 Feb 2007 16:10:26 -0500
Message-ID: <op.tnrbrocsunckof@usensfaibisl2e.eng.emc.com>
In-Reply-To: <op.tnkdlbgsrwwil4@brcsmondepl2c.corp.emc.com>
User-Agent: Opera Mail/9.10 (Win32)
X-PMX-Version: 4.7.1.128075, Antispam-Engine: 2.5.0.283055, Antispam-Data: 2007.2.14.122933
X-PerlMx-Spam: Gauge=, SPAM=2%, Reason='EMC_FROM_0+ -2, __CP_URI_IN_BODY 0, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0, __USER_AGENT 0'
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Feb 2007 22:06:37 -0500, Sorin Faibish <sfaibish@emc.com> wrote:

> Introducing DualFS
>
> File System developers played with the idea of separation of
> meta-data from data in file systems for a while. The idea was
> lately revived by a small group of file system enthusiasts
>  from Spain (from the little known University of Murcia) and
> it is called DualFS. We believe that the separation idea
> will bring to Linux file systems great value.
>
> We see DualFS as a next-generation journaling file system which
> has the same consistency guaranties as traditional journaling
> file systems but better performance characteristics. The new file
> system puts data and meta-data on different devices (usually, two
> partitions on the same disk or different disks), and manages them
> in very different ways:
>
> 1. DualFS has only one copy of every meta-data block. This copy is
>     in the meta-data device,
>
> 2. The meta-data device is a log which is used by DualFS both to
>     read and to write meta-data blocks.
>
> 3. DualFS avoids an extra copy of meta-data blocks, which allow
>     DualFS to achieve higher performance than other journaling file
>     systems.
>
> 4. DualFS implements performance enhancements: meta-data prefetch,
>     on-line meta-data relocation and faster fsck and mkfs operations.
>
> 5. DualFS file system is suitable for use with TB and PB of storage
>
> We have carried out different experiments which compare DualFS and
> other popular Linux file systems, namely, Ext2, Ext3, XFS, JFS, and
> ReiserFS. The results, both performance and management, prove the
> value of the new file system design based on the separation of data
> and metadata which increase performance dramatically up to 97% by
> simply using an additional partition of same disk.
>
> We have performed extensive tests using micro-benchmarks as well
> as macro-benchmarks including Postmark v1.5, SpecWeb99, TPCC-uva.
> We also measured performance of maintenance tasks like mkfs and
> fsck which all show that DualFS performance is superior to all the
> other file systems tested with performance advantage in the range
> between 50-300% depending on the benchmark and the configuration.
> And all this performance advantage is a direct result of the
> separation of the meta-data and data.
>
> The project started in 2000 by Juan Piernas Canovas as the primary
> and almost unique contributor, with some small contributions by Toni
> Cortes, and Jose M. Garcia. The project was stopped for some time. We
> restarted the project last year, and after several months of updates
> and tests we created a SourceForge project with the intent to share
> the value of this old and yet new concept.
>
> The DualFS code, tools and performance papers are available at:
>
>   	<http://sourceforge.net/projects/dualfs>
>
> The code requires kernel patches to 2.4.19 (oldies but goodies) and
> a separate fsck code.  The latest kernel we used it for is 2.6.11
> and we hope with you help to port it to the latest Linux kernel.
>
> We will present the architecture, principles and performance
> characterization at the LFS07 next week.
>
> We are very interested to get your feedback and criticism.
>
> Sorin Faibish and Juan Piernas Canovas
> --------------------------------------
>
>
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel"  
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>



-- 
Using Opera's revolutionary e-mail client: http://www.opera.com/mail/
