Return-Path: <linux-kernel-owner+w=401wt.eu-S1757825AbYHUXto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757825AbYHUXto (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 19:49:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752614AbYHUXtX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 19:49:23 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:33470 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752116AbYHUXtV (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 19:49:21 -0400
Message-ID: <48ADFE65.1050007@snapgear.com>
Date: Fri, 22 Aug 2008 09:46:45 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Jamie Lokier <jamie@shareable.org>
CC: Jared Hulbert <jaredeh@gmail.com>, Linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@logfs.org>, tim.bird@AM.SONY.COM,
       cotte@de.ibm.com, nickpiggin@yahoo.com.au
Subject: Re: [PATCH 00/10] AXFS: Advanced XIP filesystem
References: <48AD00C4.6060302@gmail.com> <20080821110749.GA1926@shareable.org>
In-Reply-To: <20080821110749.GA1926@shareable.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Jamie Lokier wrote:
> Jared Hulbert wrote:
>> The biggest improvement is in the way AXFS allows for each page to be XIP or
>> not.  First, a user collects information about which pages are accessed on a
>> compressed image for each mmap()ed region from /proc/axfs/volume0.  That
>> 'profile' is used as an input to the image builder.  The resulting image has
>> only the relevant pages uncompressed and XIP.  The result is smaller memory
>> sizes and faster launches.
> 
> Sounds great, really nice idea.
> 
> How does it fare with no MMU?  Can the profiler and image builder lay
> out the XIP pages in such a way that no-MMU mmaps can map those regions?

The key for XIP on noMMU would be the ability to store a
file as one complete contiguous chunk. Can AXFS do this?

Regards
Greg



------------------------------------------------------------------------
Greg Ungerer  --  Chief Software Dude       EMAIL:     gerg@snapgear.com
Secure Computing Corporation                PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
