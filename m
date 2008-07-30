Return-Path: <linux-kernel-owner+w=401wt.eu-S1754653AbYG3QJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653AbYG3QJp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 12:09:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752322AbYG3QJh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 12:09:37 -0400
Received: from web31708.mail.mud.yahoo.com ([68.142.201.188]:49074 "HELO
	web31708.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751829AbYG3QJg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 12:09:36 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=kauAwvq643SoNx5SMxqsT93UK8oHZuT0CkbubdAVc3xUi2lV5wm/K9fJ2sdE6TqmmVPDTRRe8+d4iE5nxCG/Z0EbWPqLqqj++MBURDgC1tunqaIORHMRYaoJv9kDzYAmTwlpU4AwoaQpamJCh6ZmA0ThxN5YKeIo7Jyg1Cg62W4=;
X-Mailer: YahooMailRC/1042.48 YahooMailWebService/0.7.218
Date: Wed, 30 Jul 2008 09:09:36 -0700 (PDT)
From: Sanka Piyaratna <cesanka@yahoo.com>
Subject: Re: PCIe device driver question
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Message-ID: <257182.1206.qm@web31708.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

Actually the failures occur at addresses lot higher than this range, I am noticing the failure at dma address 0x0000000037845000. This would be at around 900MB ?

Thanks

Sanka



----- Original Message ----
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Sanka Piyaratna <cesanka@yahoo.com>
Cc: linux-kernel@vger.kernel.org
Sent: Thursday, 31 July, 2008 1:17:18 AM
Subject: Re: PCIe device driver question

On Wed, 30 Jul 2008 09:00:58 -0700 (PDT)
Sanka Piyaratna <cesanka@yahoo.com> wrote:

> Hi,
> 
> I am currently developing a PCIe data capture card hardware and the
> device drivers to drive this. I have implemented DMA on the data
> capture and the scatter-gather DMA is implemented in the hardware.  I
> am testing this in an X86_64 architecture machine with 4 GB of RAM. I
> am able to successfully dma data into any memory (dma) address >
> 0x0000_0001_0000_0000. However, my problem is to dma data to any
> address less than this. When I try to DMA data to an address less than
> 0x0000_0001_0000_0000, the hardware device hangs indicating that the
> address does not exist.

Assuming the failures are in the range 640K-1MB then I would imagine your
bridge doesn't permit transfers via DMA to the ISA hole.



      Find a better answer, faster with the new Yahoo!7 Search. www.yahoo7.com.au/search
