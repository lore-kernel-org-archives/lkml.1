Return-Path: <linux-kernel-owner+w=401wt.eu-S1754685AbXFON70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685AbXFON70 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 09:59:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751348AbXFON7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 09:59:18 -0400
Received: from s2.ukfsn.org ([217.158.120.143]:54075 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752598AbXFON7Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 09:59:16 -0400
Message-ID: <46729B20.309@dgreaves.com>
Date: Fri, 15 Jun 2007 14:58:56 +0100
From: David Greaves <david@dgreaves.com>
User-Agent: Mozilla-Thunderbird 2.0.0.0 (X11/20070601)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Chinner <dgc@sgi.com>, xfs@oss.sgi.com,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.osdl.org>, Neil Brown <neilb@suse.de>,
       Jeff Garzik <jgarzik@pobox.com>, jens.axboe@oracle.com
Subject: Re: [PATCH] block: always requeue !fs requests at the front
References: <200706020122.49989.rjw@sisk.pl> <46706968.7000703@dgreaves.com> <alpine.LFD.0.98.0706131507360.14121@woody.linux-foundation.org> <200706140115.58733.rjw@sisk.pl> <46714ECF.8080203@gmail.com> <46715A66.8030806@suse.de> <20070615094246.GN29122@htj.dyndns.org>
In-Reply-To: <20070615094246.GN29122@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> David, please test this.  Jens, does it look okay?

Phew!

Works for me.

I applied it to 2.6.22-rc4 (along with 
sata_promise_use_TF_interface_for_polling_NODATA_commands.patch) hibernate and 
resume worked.

Thanks for digging it out Tejun (and everyone else!) :)

David
