Return-Path: <linux-kernel-owner+w=401wt.eu-S1752963AbYH2GCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752963AbYH2GCY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 02:02:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751221AbYH2GCQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 02:02:16 -0400
Received: from smtp.nokia.com ([192.100.122.230]:32855 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203AbYH2GCO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 02:02:14 -0400
Subject: Re: [PATCH 2/2][MTD] Add support for > 2GiB MTD devices
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
       linux-mtd-bounces@lists.infradead.org,
       "'Bruce Leonard'" <brucle@earthlink.net>, Bruce_Leonard@selinc.com,
       linux-kernel@vger.kernel.org, Tim Anderson <tanderson@mvista.com>,
       linux-mtd@lists.infradead.org,
       "'Andrew Morton'" <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <20080827152534.GB1371@logfs.org>
References: <1219817017.18027.149.camel@sauron>
	 <000201c9080d$0bce0d20$6b01a8c0@mvista.com>
	 <20080827093920.1bdb44c2@lxorguk.ukuu.org.uk>
	 <1219827692.7107.170.camel@pmac.infradead.org>
	 <20080827143416.GA1371@logfs.org> <1219848463.18027.166.camel@sauron>
	 <20080827152534.GB1371@logfs.org>
Content-Type: text/plain; charset=utf-8
Date: Fri, 29 Aug 2008 08:48:07 +0300
Message-Id: <1219988887.4036.7.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 29 Aug 2008 05:51:33.0903 (UTC) FILETIME=[4AF6A9F0:01C9099B]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-08-27 at 17:25 +0200, Jörn Engel wrote:
> > I would like to make udev creating MTD devices, instead of creating them
> > by hands. Adding MTD to LDM would anyway introduce corresponding sysfs
> > files, right? This means we would have one more interface anyway.
> 
> Could be useful, I don't mind you sending a patch.  However, does this
> means that MEMGETINFO64 or some other ioctl should not be done?  Should
> flash_erase open, read and close 8 seperate files instead of doing a
> single ioctl?  And should our support for large devices wait for the
> sysfs support that has been talked about and not done for about two
> years already?

Up to dwmw2, but I do not mind if the answer to all the above questions
is "yes" :-)

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

