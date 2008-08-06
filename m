Return-Path: <linux-kernel-owner+w=401wt.eu-S932126AbYHFPpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932126AbYHFPpt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 11:45:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760371AbYHFPk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 11:40:59 -0400
Received: from brmea-mail-4.Sun.COM ([192.18.98.36]:39028 "EHLO
	brmea-mail-4.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760307AbYHFPk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 11:40:56 -0400
X-Greylist: delayed 524 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Aug 2008 11:40:56 EDT
Date: Wed, 06 Aug 2008 07:40:40 -0400
From: David Collier-Brown <davecb@sun.com>
Subject: Sidebar to [malware-list] [RFC 0/5] [TALPA] Intro to a linux interface
 for on access scanning
In-reply-to: <1217961574.27684.129.camel@localhost.localdomain>
To: Eric Paris <eparis@redhat.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
       "Press, Jonathan" <Jonathan.Press@ca.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       linux-security-module@vger.kernel.org
Reply-to: davecb@sun.com
Message-id: <48998DB8.3@sun.com>
MIME-version: 1.0
Content-type: text/plain; format=flowed; charset=us-ascii
Content-transfer-encoding: 7BIT
X-Accept-Language: en-us, en
References: <1217883616.27684.19.camel@localhost.localdomain>
 <20080804223249.GA10517@kroah.com>
 <1217896374.27684.53.camel@localhost.localdomain>
 <2629CC4E1D22A64593B02C43E855530304807431@USILMS12.ca.com>
 <1217948212.27684.120.camel@localhost.localdomain>
 <2629CC4E1D22A64593B02C43E855530304807436@USILMS12.ca.com>
 <1217956796.11547.12.camel@paris.rdu.redhat.com>
 <20080805103840.1aaa64a5@infradead.org>
 <2629CC4E1D22A64593B02C43E85553030480743B@USILMS12.ca.com>
 <20080805112747.2c3c4650@infradead.org>
 <1217961574.27684.129.camel@localhost.localdomain>
User-Agent: Mozilla/5.0 (X11; U; SunOS sun4u; en-US; rv:1.7) Gecko/20041221
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Press, Jonathan" <Jonathan.Press@ca.com> wrote:
>>but close is... very limited in value. Open is a discrete event
>>traditionally associated withh permission checks.
>>Close... not so.  (And if you mmap memory, you can then close the file
>>and still write to it via the mmap)

Eric Paris wrote:
> I think we all agree that open is the most interesting time for scanning
> operations, but as Jonathan points out there is some value (even if not
> perfect value) in looking at closes as well.

Open for read is the "traditional" time for scanning, but the
sequence (open for write) -> change -> (time passes or close happens) 
is specifically a good time to do content checking, so as to have the 
answer to the check available for the open for read.

I'd suggest "read" and "write" are the two cases that are interesting,
and that we've been using 'open" an "close" for a not very good
approximation to them (;-))

--dave
-- 
David Collier-Brown            | Always do right. This will gratify
Sun Microsystems, Toronto      | some people and astonish the rest
davecb@sun.com                 |                      -- Mark Twain
cell: (647) 833-9377, bridge: (877) 385-4099 code: 506 9191#
