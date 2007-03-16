Return-Path: <linux-kernel-owner+w=401wt.eu-S933227AbXCPUM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933227AbXCPUM6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 16:12:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933304AbXCPUM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 16:12:58 -0400
Received: from mailbigip.dreamhost.com ([208.97.132.5]:52885 "EHLO
	swarthymail-a2.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933227AbXCPUM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 16:12:57 -0400
X-Greylist: delayed 5118 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Mar 2007 16:12:57 EDT
Date: Fri, 16 Mar 2007 17:12:53 -0300
From: John Coppens <john@jcoppens.com>
To: "Lee Revell" <rlrevell@joe-job.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Conflict between ide and usb?
Message-Id: <20070316171253.2014deaf.john@jcoppens.com>
In-Reply-To: <75b66ecd0703161252l60dcbd81s3c9beb7cb91b6c14@mail.gmail.com>
References: <20070316154735.6de11eca.john@jcoppens.com>
	<75b66ecd0703161252l60dcbd81s3c9beb7cb91b6c14@mail.gmail.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.20; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Mar 2007 15:52:12 -0400
"Lee Revell" <rlrevell@joe-job.com> wrote:

> On 3/16/07, John Coppens <john@jcoppens.com> wrote:
> > The problem I have, is that when I copy a file from a DVD to harddisk,
> > the internet connection almost dies (it slows down terribly, so much
> > so that established connections actually disconnect, ping looses
> > packets, DNS lookup fails, etc). After copy ends, all returns to
> > normal.
> 
> Sounds like DMA starvation, it's been seen in the past with some SATA
> controllers.  Presumably vendors do it to improve benchmark scores.

Hi Lee.

In this case SATA isn't used, as the copy is from IDE to IDE. But I
doubt bandwidth has anything to do with it. The DVD transfer rate rarely 
reaches 3.3 MB/s - which by itself isn't normal.

> You can confirm it by forcing the hard drive and/or DVD drive to a
> lower speed if your BIOS allows it.

No... I didn't find any way to lower the speed.

Thanks
John
