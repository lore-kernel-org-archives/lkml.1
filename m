Return-Path: <linux-kernel-owner+w=401wt.eu-S1753023AbYHRBLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023AbYHRBLt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 21:11:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751167AbYHRBLl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 21:11:41 -0400
Received: from brmea-mail-2.Sun.COM ([192.18.98.43]:45553 "EHLO
	brmea-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947AbYHRBLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 21:11:40 -0400
Date: Sun, 17 Aug 2008 17:11:21 -0400
From: David Collier-Brown <davecb@sun.com>
Subject: Re: [malware-list] TALPA - a threat model?  well sorta.
In-reply-to: <20080817162603.065c756f@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Eric Paris <eparis@redhat.com>, Jan Harkes <jaharkes@cs.cmu.edu>,
       Rik van Riel <riel@redhat.com>,
       "Press, Jonathan" <Jonathan.Press@ca.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, peterz@infradead.org,
       linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       hch@infradead.org, andi@firstfloor.org, viro@ZenIV.linux.org.uk
Reply-to: davecb@sun.com
Message-id: <48A893F9.8090000@sun.com>
MIME-version: 1.0
Content-type: text/plain; format=flowed; charset=us-ascii
Content-transfer-encoding: 7BIT
X-Accept-Language: en-us, en
References: <1218645375.3540.71.camel@localhost.localdomain>
 <20080813172437.3ed90b0d@lxorguk.ukuu.org.uk>
 <1218646065.3540.75.camel@localhost.localdomain>
 <20080813173722.13c9c306@lxorguk.ukuu.org.uk>
 <1218646833.3540.82.camel@localhost.localdomain>
 <20080813205906.559d3f37@lxorguk.ukuu.org.uk>
 <2629CC4E1D22A64593B02C43E855530304AE4BC2@USILMS12.ca.com>
 <20080813173529.7069b5f1@cuia.bos.redhat.com>
 <20080815201622.GD31584@cs.cmu.edu> <20080815150509.20ffb91d@infradead.org>
 <1219015177.27389.1.camel@localhost.localdomain>
 <20080817162603.065c756f@infradead.org>
User-Agent: Mozilla/5.0 (X11; U; SunOS sun4u; en-US; rv:1.7) Gecko/20041221
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> Eric Paris <eparis@redhat.com> wrote:
>>/me is HSM clueless and trying to include their needs is proving a
>>challenge.
> 
> 
> I bet it's the same; until you read/mmap... no need to get the data.
> 
> you wouldn't want an "ls -l" or "find" to restore your entire system
> from tape after all :)
> 

The HSMs I'm familiar with keep the inode and the first block of the file on-disk,
so that stat and file commands work. For Windows, you also need to keep the pointer
to the icon to use valid, or create a fake one.

--dave
-- 
David Collier-Brown            | Always do right. This will gratify
Sun Microsystems, Toronto      | some people and astonish the rest
davecb@sun.com                 |                      -- Mark Twain
cell: (647) 833-9377, bridge: (877) 385-4099 code: 506 9191#
