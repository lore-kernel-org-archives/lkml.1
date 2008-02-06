Return-Path: <linux-kernel-owner+w=401wt.eu-S1757950AbYBFU7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757950AbYBFU7Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 15:59:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756359AbYBFU7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 15:59:16 -0500
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:54600 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757009AbYBFU7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 15:59:15 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: Randy Dunlap <randy.dunlap@ORACLE.COM>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
In-Reply-To: <20080205170939.10085936.randy.dunlap@oracle.com>
References: <1201815920-24669-1-git-send-email-ijc@hellion.org.uk>
	 <1201815920-24669-2-git-send-email-ijc@hellion.org.uk>
	 <1201815920-24669-3-git-send-email-ijc@hellion.org.uk>
	 <47A24765.3070300@zytor.com>
	 <1201856568.3804.8.camel@cthulhu.hellion.org.uk>
	 <20080205170939.10085936.randy.dunlap@oracle.com>
Content-Type: text/plain
Date: Wed, 06 Feb 2008 20:58:59 +0000
Message-Id: <1202331539.7333.9.camel@cthulhu.hellion.org.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 192.168.1.181
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [PATCH] x86: add a crc32 checksum to the kernel image.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.0 c=1 a=GH9t1naC91kA:10 a=frweXNZgSzYHrrxySyutIQ==:17 a=i5hZOBjDUlFRciee8FUA:9 a=v0-GX6D0azZ3pQZ0V80FNRDbvfwA:4 a=WuK_CZDBSqoA:10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-02-05 at 17:09 -0800, Randy Dunlap wrote:
> On Fri, 01 Feb 2008 09:02:48 +0000 Ian Campbell wrote:
> >  
> > +**** THE IMAGE CHECKSUM
> > +
> > +The CRC-32 is calculated over the entire file using an initial
> > +remainder of 0xffffffff.  The checksum is appended to the file
> 
> Run-on sentences.
> Use period (full stop) or semi-colon at end of above sentence.
> If using a period, capitalize the next word.  Thanks.
> 
> 
> > +therefore the CRC of the file up to the limit specified in the syssize
> > +field of the header is always 0.

Thanks. I went with:

+The CRC-32 is calculated over the entire file using an initial
+remainder of 0xffffffff.  The checksum is appended to the file;
+therefore the CRC of the file up to the limit specified in the syssize
+field of the header is always 0.


-- 
Ian Campbell

If the master dies and the disciple grieves, the lives of both have
been wasted.

