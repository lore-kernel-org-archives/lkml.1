Return-Path: <linux-kernel-owner+w=401wt.eu-S1751745AbYDEClw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751745AbYDEClw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 22:41:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750941AbYDEClm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 22:41:42 -0400
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:40630 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750749AbYDECll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 22:41:41 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=WITA1DsszNB/OJxX9Nps2YQmaUVp3SU7I9lgmaOpSw0IUByqWWj3CWeqNhUHok+r+qTBGeMf4WlEDfcZVjIIsquztPC5BhrCZFx8pUwpBtzH7qdKnaa/gzJDupmBMwIh5IRWTRY1fwhXYCOiqqqFtBI0lL5nChwUOU3I3dNrBCM=  ;
X-YMail-OSG: x_BKMdgVM1kz21D.1pEdIk0PqyVHXhlCA0cDUloy3bsyqqaOIK99b_vUR6Vz6brzWdQQOhpRgg--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Kyungmin Park" <kmpark@infradead.org>
Subject: Re: [PATCH] jffs2 summary allocation
Date: Fri, 4 Apr 2008 19:17:04 -0700
User-Agent: KMail/1.9.6
Cc: "Josh Boyer" <jwboyer@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org,
       "Michael Trimarchi" <trimarchimichael@yahoo.it>,
       spi-devel-general@lists.sourceforge.net,
       "Andrew Morton" <akpm@linux-foundation.org>, dwmw2@infradead.org,
       linux-arm-kernel@lists.arm.linux.org.uk
References: <713171.37644.qm@web26213.mail.ukl.yahoo.com> <1207357870.3224.89.camel@vader.jdub.homelinux.org> <9c9fda240804041829r5a768b39n340926485aa12687@mail.gmail.com>
In-Reply-To: <9c9fda240804041829r5a768b39n340926485aa12687@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804041917.05294.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 April 2008, Kyungmin Park wrote:
> So I now changed the kmalloc eraseblock to vmalloc at both jffs2 and mtd-utils.

I hope you meant: vmalloc changed to kmalloc?

And mtd-utils is userspace, not kernel, so it can't care...

