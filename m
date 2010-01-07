Return-Path: <linux-kernel-owner+w=401wt.eu-S1751926Ab0AGNKI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926Ab0AGNKI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 08:10:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751706Ab0AGNKH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 08:10:07 -0500
Received: from web31703.mail.mud.yahoo.com ([68.142.201.183]:25442 "HELO
	web31703.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751623Ab0AGNKG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 08:10:06 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Jan 2010 08:10:06 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=w8vfm0jJDkwL4shVD6WmsdWqEs3yyVJZ2VTvxk8eRNF5rzOEXB1Cykd0a4GNgWEBU+5Z13E2jKPXezG+3NEzwClXuz+Y0nlqjOYd8tTXtRKMInfngIw+C5YTC9sNedjrUiI6bXytvgnw2cEv9OdDb7HlZ0ab/0XJzX3eupxoCiU=;
Message-ID: <224142.50171.qm@web31703.mail.mud.yahoo.com>
X-YMail-OSG: fWZEwHwVM1l7OL.Q0MaJ9JTsbn3s1Pv0T7Ls17FLW7ga8nWGH7Bm1h6k77oxUyOUkIGJ9PR_yu.pc2qaysvTHUnkMVas7nT8hO1xKjqS5jrjhzK2oElIfzMm7mc9FnRymsv5EJI91TZAeAP4tsXLWQW8Sc24TZICipf_ok9JigVaVixM3SPUIWK2n6t1aLedZ_8IecX5RZfEneDo9WMYOKVVqd6xCaUj2G6gaPynJnxBrNc9Dd2xeTqWgv4tmDmG2whgsF2hnKpV4gVaPMd_A5dUvQUu.NL8s_9t1DnslOgkGERz1j0DkT3pnOKmeL52RN1ZUAputXlZYwKzYdt_9qiBUbcW.C.a1zdYVoD6FO__sGUMhkTNC_AvpRL80vuJ3YmPTRsMQMzknsSUw2iHnqNEQ6_NsbiZKMIh0FW_br.8eP42Juyte.lke7MV4y.WKS10P3CMC_mx36A4fL1JGkrggLfq5N_pl2Kk
X-Mailer: YahooMailRC/240.3 YahooMailWebService/0.8.100.260964
Date: Thu, 7 Jan 2010 05:03:24 -0800 (PST)
From: Sanka Piyaratna <cesanka@yahoo.com>
Subject: demand driven memory allocation
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have implemented a PCIe device using an Xilinx Virtex 5 device. I have an A/D controller sampling an RF signal based on the incoming signal level. These samples are transferred to the computer via the FPGA. I have implemented scatter-gather DMA using a DMA parameter (Page address and size) FIFO where a page table can be programmed where the incoming data would go. The device supports a programmable interrupt period where, once N number of pages are filled in the PC memory, an interrupt would be triggered and the new DMA parameters could be loaded in to the free memory in the FIFO. I can allocate a large enough number of pages in the kernel for the signal to be captured. I would like to create a pointer that the user mode programs can access using the pages that has got all the received signal. I want to have the user mode application progressing this data buffer while the next set of pages from my kernel page pool is getting filled. 

I am wondering if anyone could suggest me the best way to address this situation. I have implemented the mmap(). However, as I understand it, the length of the memory block need to be known to call mmap().

Thanks and regards,

Sanka Piyaratna



      __________________________________________________________________________________
See what's on at the movies in your area. Find out now: http://au.movies.yahoo.com/session-times/
