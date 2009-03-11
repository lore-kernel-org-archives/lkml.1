Return-Path: <linux-kernel-owner+w=401wt.eu-S1754158AbZCKTOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158AbZCKTOS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 15:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752898AbZCKTOH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 15:14:07 -0400
Received: from web50112.mail.re2.yahoo.com ([206.190.39.149]:28846 "HELO
	web50112.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752191AbZCKTOH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 15:14:07 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Mar 2009 15:14:06 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=shC74c3h7mo2teEX4vbsp+wfitMv1xYum60jHbg54BjTkXMdW6Uch1ZJnv3qoDh+kzfIG0KCagAGfFerlzhwYqlmlBviIHpDrUFeMbEnmx4TcrtVMIrNMSWFsYYu55JDsRYyTnLBMbA8OYQwaWsb8gO1nh/Ax8ezg/nc8EX1vK0=;
Message-ID: <964156.19042.qm@web50112.mail.re2.yahoo.com>
X-YMail-OSG: D.YbDoAVM1knJCpYGV6UaccUPZN2TMCvux1A0QZ00cqE5d6ZG14YjuxwX_rg_lkJ80OU.mi8DoiEpHYvZsmHqfJSWwdSDXtYK_OckCi3DEJW4Apuh779cJriW5GxdG_w07AiQ2bCkSYhyeMGEKzxz.gCc3rT_crvwviCwBlsEAa8ZPU4IJfEtHqqB6Iap04sn6VCeHDVcsHv5aZS6PLMHvpa.w9MzS5lQdk-
X-Mailer: YahooMailClassic/5.1.19 YahooMailWebService/0.7.289.4
Date: Wed, 11 Mar 2009 12:07:23 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Subject: Re: [v2 PATCH 0/7] Add AMD8111 and AMD8131 EDAC drivers
To: linux-kernel@vger.kernel.org, bluesmoke-devel@lists.sourceforge.net,
       Harry Ciao <qingtao.cao@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- On Tue, 3/10/09, Harry Ciao <qingtao.cao@windriver.com> wrote:

> From: Harry Ciao <qingtao.cao@windriver.com>
> Subject: [v2 PATCH 0/7] Add AMD8111 and AMD8131 EDAC drivers
> To: linux-kernel@vger.kernel.org, bluesmoke-devel@lists.sourceforge.net
> Date: Tuesday, March 10, 2009, 9:25 PM
> 
> Hi,
> 
> This is the v2 series of patches for EDAC AMD8111 &
> AMD8131 drivers.
> I have integrated suggestions from Bert, Greg and Andrew.
> Tests all passed on Maple platform, these modules could be
> properly
> loaded/unloaded, with their sysfs interfaces
> created/cleaned.
> 
> Any suggestions are warmly welcomed!
> 
> Best regards,
> 
> Harry
> 
> 
> Comments:        
> ---------
> Introduce AMD8111 EDAC driver, which makes use of error
> detections 
> on the LPC Bridge Controller and PCI Bridge Controller on
> the AMD8111 
> HyperTransport I/O Hub.
> 
> Introduce AMD8131 EDAC driver source file, which makes use
> of error
> detections on the PCI-X Bridge Controllers on the AMD8131
> HyperTransport
> PCI-X Tunnel.
> 
> Since both AMD8111 and AMD8131 EDAC drivers would use
> edac_pci_ctl_info
> structures, EDAC core has to take the responsibility to
> allocate a unique
> "edac_pci_idx" for each of them, by newly added
> edac_pci_alloc_index().
> 
> Note, by far only POLL mode is supported, and they have
> been tested on 
> MAPLE platform, from below test logs we can tell that they
> could be 
> correctly installed and removed, and export proper sysfs
> interfaces.

harry,

thanks for the new edac_pci_alloc_index(). I have been meaning to solve that issue for sometime, but didn't have a pressing need to do so. You brought one and solved it.

thanks again

doug t

