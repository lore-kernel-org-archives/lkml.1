Return-Path: <linux-kernel-owner+w=401wt.eu-S1754588AbXL1Bjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588AbXL1Bjf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 20:39:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753482AbXL1Bj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 20:39:26 -0500
Received: from web52903.mail.re2.yahoo.com ([206.190.49.13]:27170 "HELO
	web52903.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752773AbXL1BjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 20:39:25 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=Ioq8i5ENyDHlMcmbDy0JqYietCZTptlI0Kk3sNYqsJ3Tx8OayeuO9GOOB63svhlg6k81bMri+5KzCKWz0jwrfdq4qDQ7CfzWSWK/G5YCoUhwz00JTK/IF5pvImIiVbBBYaqFLL3S7kBBV4GunHNg7kMruZ7V48fDwb32kWYcUuo=;
X-YMail-OSG: aSeB8xsVM1nYqH2OQgoi62tYksn2bP2iKbJ.H.1ievCnorUT4AfoO1zqOy_dJYs9TqYm93dsx1LAfNefXJAJnH10U_LzL._3ykErOy1SbIbtGbWm9yfmlCSbKU1pZ1YmWrV_DWUXwttxnZGrAJPkxcS_Sw--
Date: Fri, 28 Dec 2007 01:39:24 +0000 (GMT)
From: Chris Rankin <rankincj@yahoo.com>
Subject: Re: [2.6.23.9] hostap_plx locks up PC when reading PCI I/O memory
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dcbw@redhat.com, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
In-Reply-To: <20071212020325.96dbf41b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <463453.24516.qm@web52903.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- Andrew Morton <akpm@linux-foundation.org> wrote:
> > > Did any earlier version of the 2.6 kernel work OK?

Kernel 2.6.14 does not work any better than 2.6.23.x, and my F8 userspace environment rejects a
2.4.35 kernel. I will try a 2.6.0 kernel next, but have noticed tonight that a stock Fedora kernel
also hangs when it tries to load the orinoco_plx.ko kernel module. (This module also expect a
PLX9052 bridge.)

For reference, I have found a datasheet for the PLX9052 here:

http://www.dyneng.com/plx_9052.pdf

One theory could be that the PLX9052 chip requires an extra initialisation step for an Intel
SE440BX-2 motherboard (the board that hangs) vs an older Intel Zappa motherboard (where the chip
works OK). However, I don't know anything like enough about PCI to guess what such a step might
be.

Cheers,
Chris



      __________________________________________________________
Sent from Yahoo! Mail - a smarter inbox http://uk.mail.yahoo.com

