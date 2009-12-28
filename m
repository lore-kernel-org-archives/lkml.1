Return-Path: <linux-kernel-owner+w=401wt.eu-S1752018AbZL1Vna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018AbZL1Vna (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 16:43:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751417AbZL1Vn3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 16:43:29 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:27739 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbZL1Vn2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 16:43:28 -0500
MIME-Version: 1.0
Message-ID: <dfed453e-7cc5-4a17-a45a-fe1d27592615@default>
Date: Mon, 28 Dec 2009 13:41:02 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Nitin Gupta <ngupta@vflare.org>, Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, jeremy@goop.org,
       xen-devel@lists.xensource.com, tmem-devel@oss.oracle.com,
       Rusty Russell <rusty@rustcorp.com.au>, Rik van Riel <riel@redhat.com>,
       dave.mccracken@oracle.com, sunil.mushran@oracle.com,
       Avi Kivity <avi@redhat.com>, Schwidefsky <schwidefsky@de.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, chris.mason@oracle.com,
       linux-mm <linux-mm@kvack.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: RE: Tmem [PATCH 0/5] (Take 3): Transcendent memory
In-Reply-To: <20091228205102.GC1637@ucw.cz>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1.4  (308245) [OL
 9.0.0.6627]
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4B39264A.0092:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > One feature of frontswap which is different than ramzswap is
> > that frontswap acts as a "fronting store" for all configured
> > swap devices, including SAN/NAS swap devices.  It doesn't
> > need to be separately configured as a "highest priority" swap
> > device.  In many installations and depending on how ramzswap
> 
> Ok, I'd call it a bug, not a feature :-).
> 								Pavel

I agree it has little value (or might be considered a bug)
when managing Linux on a physical machine.  But when
Linux is running in a virtual machine, it's one less thing
that a sysadmin needs to understand and configure.
