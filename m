Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755780Ab0CHUWR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 15:22:17 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:55069 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755714Ab0CHUWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 15:22:06 -0500
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
       James Bottomley <James.Bottomley@suse.de>, Tejun Heo <tj@kernel.org>,
       "linux-ide\@vger.kernel.org" <linux-ide@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Daniel Taylor <Daniel.Taylor@wdc.com>, Jeff Garzik <jeff@garzik.org>,
       Mark Lord <kernel@teksavvy.com>, tytso@mit.edu,
       hirofumi@mail.parknet.co.jp, Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, irtiger@gmail.com,
       Matthew Wilcox <matthew@wil.cx>, aschnell@suse.de, knikanth@suse.de,
       jdelvare@suse.de
Subject: Re: ATA 4 KiB sector issues.
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <4B947393.2050002@kernel.org>
	<1268031640.4389.11.camel@mulgrave.site>
	<yq1vdd6bzgz.fsf@sermon.lab.mkp.net>
	<yq1mxyibz7o.fsf@sermon.lab.mkp.net>
	<yq1iq96bz22.fsf@sermon.lab.mkp.net> <4B9546E6.6050006@zytor.com>
Date: Mon, 08 Mar 2010 15:19:05 -0500
In-Reply-To: <4B9546E6.6050006@zytor.com> (H. Peter Anvin's message of "Mon,
	08 Mar 2010 10:50:14 -0800")
Message-ID: <yq1fx4aa7nq.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4B955C20.00D8:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "hpa" == H Peter Anvin <hpa@zytor.com> writes:

hpa> On the flipside, though, there really is very little net benefit to
hpa> 4K as opposed to 512 byte logical sectors: the additional protocol
hpa> overhead is relatively minimal, and as long as writes are aligned
hpa> full blocks, there shouldn't be any additional overhead on either
hpa> the OS or the drive side.  On the plus side, you get full
hpa> compatibility with the existing software stack.  The equation
hpa> really seems rather simple.

4KB sectors are not a win for anybody except the drive vendors.

There is a push in the industry right now to keep the 512-byte logical
blocks forever.  The first step would be to report misaligned accesses
or accesses that are not a multiple of the physical block size.  Second
step would be to eventually reject any write that's not a properly
aligned multiple of the physical block size.

-- 
Martin K. Petersen	Oracle Linux Engineering
