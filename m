Return-Path: <linux-kernel-owner+w=401wt.eu-S1754730AbXJWWKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730AbXJWWKg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 18:10:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752644AbXJWWK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 18:10:29 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:47564 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752504AbXJWWK2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 18:10:28 -0400
Message-ID: <471E7151.8070805@garzik.org>
Date: Tue, 23 Oct 2007 18:10:25 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: linux-kernel@vger.kernel.org, Randy Dunlap <randy.dunlap@oracle.com>,
       Greg KH <greg@kroah.com>
Subject: Re: const vs __{dev}initdata
References: <200710232335.56766.bzolnier@gmail.com>
In-Reply-To: <200710232335.56766.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:
> Hi,
> 
> It seems that const cannot be (officialy) mixed with __{dev}initdata,
> 
> include/linux/init.h:
> ...
>  *
>  * Also note, that this data cannot be "const".
>  */
> ...
> 
> [ BTW Greg: this doesn't seem to be mentioned in LDD3. ]
> 
> Any reason for this limitation (other than not having .init.rodata section
> and __const__{dev}initdata tag)?  There are places where we really would like
> to have both, i.e. struct ide_port_info in drivers/ide.

Thank you for asking this question...  we really do need a solution for 
this.

As you point out, there are many valid cases for both const and initdata.

	Jeff



