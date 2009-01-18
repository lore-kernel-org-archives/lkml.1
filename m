Return-Path: <linux-kernel-owner+w=401wt.eu-S934738AbZARRqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934738AbZARRqm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 12:46:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933859AbZARRqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 12:46:33 -0500
Received: from web110610.mail.gq1.yahoo.com ([67.195.13.201]:32833 "HELO
	web110610.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933835AbZARRqc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 12:46:32 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=1bmaiHzdh9PCM4zj2IdQTpt2Z5KO/7Q1vCkygzaM2BMpo/mbWNBnrsxbSIgAQGcRgI/+YWJ6ALJ15pOOQkXZOtVQqy2smgFL7aYPaoFTUSwegtLwhJJ/Q5Vl+OZAdlwyRIjCAp/HwqfuUUtgsrX7botUr4ix9G3Iwh9ZpOEv8fM=;
X-YMail-OSG: BfFgHYQVM1nQPb1_74RbsGxZs1124zjnx094Tr_BoQMw4Ztie2dC_bq40jssDRVuSesmrpZ_a_vUyXy8JfENuN6k1FERfx2B17dth8ndbJjfROB472_xSxE3IhHDuYAIdPHLR2jShhx83y64pwj5Vc17uCaVQHJps1INHuCBn7oVHZo4rN3BdvqBp2Kv5vxPTuQDSKi1F4pkWBOcwrG0.Ipn7m9vdw--
X-Mailer: YahooMailRC/1155.45 YahooMailWebService/0.7.260.1
References: <gkt97e$ti0$1@ger.gmane.org> <20090117194045.649f55a0@osprey.hogchain.net> <767752.95325.qm@web110601.mail.gq1.yahoo.com> <20090118095231.2c73c448@osprey.hogchain.net>
Date: Sun, 18 Jan 2009 09:46:31 -0800 (PST)
From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: [atl2] warn_slowpath in dev_watchdog
To: Jay Cliburn <jcliburn@gmail.com>
Cc: linux-kernel@vger.kernel.org, Chris Snook <csnook@redhat.com>,
       jie.yang@atheros.com, atl1-devel@lists.sourceforge.net,
       netdev@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Message-ID: <789828.48438.qm@web110610.mail.gq1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Jay Cliburn <jcliburn@gmail.com>
> 
> I'd like to see the full dmesg that includes the warning, if you can
> obtain it next time it occurs.  Meanwhile, please see if this patch
> helps.

I forgot to mention, looking back I see that once the link disappeared 
(while the cable was still plugged in) on the router but partially came 
back (the the link reappears but the router doesn't serve DHCP leases 
or seemingly route packets) booting new kernels from cold would 
show the problem while network manager was trying to obtain a 
DHCP lease.

I will test your patch the next time that this happens (but this may be 
a while).



      
