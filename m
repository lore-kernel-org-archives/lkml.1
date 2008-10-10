Return-Path: <linux-kernel-owner+w=401wt.eu-S1754693AbYJJDB5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693AbYJJDB5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 23:01:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751394AbYJJDBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 23:01:48 -0400
Received: from smtp116.mail.mud.yahoo.com ([209.191.84.165]:45498 "HELO
	smtp116.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751116AbYJJDBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 23:01:48 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=bxoUue0AQ84AfgrcqGuqINAEr5H4Bw+/RvqHGOnaJFbXx4HTmK35TxEVfjLJt05J0LpTWncE5H7Rvz3+fl/z6p0XSlAxdBfZwKcgyrQr3yRX4yZCrWwYU/9TT5TyxltzjvIs5WFwQrqRgC5sQSJ7NKoVbUwdnOolhppcbeoHD1w=  ;
X-YMail-OSG: XUElRcQVM1kbP3Jpf5vWn8u0MYDGr1PBI_Edcbr8V9PnrBnmB68yuo9g.G_2MwgjSSLLPWYJDJ61PYtuS71IG9W38fvfpRsoPxNmL3Q3P6AOuqtZR6rceungr1xL8IliJYs.YjcdLlki1YFgIM_9xsP9Y_SJXghWLOImm5F0
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Meelis Roos <mroos@linux.ee>
Subject: Re: panic while doing lots of IO on lpfc
Date: Fri, 10 Oct 2008 14:01:40 +1100
User-Agent: KMail/1.9.5
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org
References: <Pine.SOC.4.64.0810091714230.5106@math.ut.ee> <200810101233.18726.nickpiggin@yahoo.com.au> <Pine.SOC.4.64.0810091919260.5106@math.ut.ee>
In-Reply-To: <Pine.SOC.4.64.0810091919260.5106@math.ut.ee>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810101401.41124.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 10 October 2008 03:21, Meelis Roos wrote:
> > Tried to lock a free page. Is the address of the page always the same,
> > and the first bit in flags always set after each reboot? Does the
> > machine pass a memtest?
>
> No, the machine does not pass memtest :(
> Thanks for the reminder.
>
> So please ignore this thread - if I find any errors with good RAM, I
> will open a new thread.

Thanks for the report anyway. Hardware errors can creep up and it
isn't always easy to distinguish them (struct page only covers < 1%
of RAM, and struct page checking often only covers a small portion
of memory -- chances would be much lager to have seen completely
random corruption).
