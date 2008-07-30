Return-Path: <linux-kernel-owner+w=401wt.eu-S1754477AbYG3QBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477AbYG3QBQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 12:01:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751747AbYG3QBB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 12:01:01 -0400
Received: from web31706.mail.mud.yahoo.com ([68.142.201.186]:44426 "HELO
	web31706.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751730AbYG3QBA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 12:01:00 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=d0FRneUp4ihemsb3zK4r2co644iRhoFgsysMUkD1w/o9O9Eh5VvekUwOXPurGdrEVuekYRZxq3h4/VEABlCm9o/E+X1BH3g4NTO/rmulv8gPyljaPi493wRkfHu1G+Jnr1rMDzUHtonTRTbSZiUWuJjVJzFiwNYmPZjWK11VRmU=;
X-Mailer: YahooMailRC/1042.48 YahooMailWebService/0.7.218
Date: Wed, 30 Jul 2008 09:00:58 -0700 (PDT)
From: Sanka Piyaratna <cesanka@yahoo.com>
Subject: PCIe device driver question
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Message-ID: <125082.62307.qm@web31706.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am currently developing a PCIe data capture card hardware and the
device drivers to drive this. I have implemented DMA on the data
capture and the scatter-gather DMA is implemented in the hardware.  I
am testing this in an X86_64 architecture machine with 4 GB of RAM. I
am able to successfully dma data into any memory (dma) address >
0x0000_0001_0000_0000. However, my problem is to dma data to any
address less than this. When I try to DMA data to an address less than
0x0000_0001_0000_0000, the hardware device hangs indicating that the
address does not exist.

I have implemented the DMA mask to be full 64 bit and my hardware is
capable of transfering data to any address < 8TB. I am using kernel
version 2.6.23.11. 

Could you please let me know what I might be doing wrong?

Thanks and regards,

Sanka


      Find a better answer, faster with the new Yahoo!7 Search. www.yahoo7.com.au/search
