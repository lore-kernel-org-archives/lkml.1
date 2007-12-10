Return-Path: <linux-kernel-owner+w=401wt.eu-S1753960AbXLJXMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960AbXLJXMf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 18:12:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752061AbXLJXM0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 18:12:26 -0500
Received: from jurassic.park.msu.ru ([195.208.223.243]:59142 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020AbXLJXMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 18:12:25 -0500
Date: Tue, 11 Dec 2007 02:12:30 +0300
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Bob Tracy <rct@frus.com>
Cc: Michael Cree <mcree@orcon.net.nz>, Kay Sievers <kay.sievers@vrfy.org>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, rjw@sisk.pl, rth@twiddle.net,
       linux-scsi@vger.kernel.org, greg@kroah.com
Subject: Re: [BUG] 2.6.23-rc3 can't see sd partitions on Alpha
Message-ID: <20071211021230.A16903@jurassic.park.msu.ru>
References: <20071209210729.A20635@jurassic.park.msu.ru> <20071210150853.DEE18DBA2@gherkin.frus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
In-Reply-To: <20071210150853.DEE18DBA2@gherkin.frus.com>; from rct@frus.com on Mon, Dec 10, 2007 at 09:08:53AM -0600
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2007 at 09:08:53AM -0600, Bob Tracy wrote:
> Ivan Kokshaysky wrote:
> > For now I have reassigned the bug #9457 to myself and will gradually hack
> > into udev...
> 
> Thanks...  Let me know if there's anything useful I can do to help.

It turns out to be yet another strncpy() bug that indeed shows up only with
certain src/dst alignments and breaks kobject_get_path(). Ugh...

Hopefully I'll have a patch tomorrow.

Ivan.
