Return-Path: <linux-kernel-owner+w=401wt.eu-S1751451AbXCTXvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751451AbXCTXvr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 19:51:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751493AbXCTXvr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 19:51:47 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:65414 "EHLO
	pd2mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451AbXCTXvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 19:51:46 -0400
Date: Tue, 20 Mar 2007 17:51:01 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: sata_nv  exceptions  in 2.6.20.3
In-reply-to: <fa.Avx6sndie+sm3ZWe+AEeEHpfxd8@ifi.uio.no>
To: Christopher Mulcahy <cmulcahy@avesi.com>
Cc: linux-kernel@vger.kernel.org
Message-id: <46007365.9090206@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.Avx6sndie+sm3ZWe+AEeEHpfxd8@ifi.uio.no>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christopher Mulcahy wrote:
> 
> My harddrives are Seagate Barracudas ( 7200.10, 500GB, ST3500630AS )
> 
> They have jumpers to toggle between 1.5Gb/s operation and 3.0Gb/s 
> operation.
> 
> When jumpered to 1.5Gbs operation, there are no problems.
> 
> Settings the drives to 3.0Gbs operation generates exceptions on only one 
> of the 4 drives, but this quickly leads to hard lock-up.  ( I don't see 
> a kernel crash-dump, but the system becomes frozen and has to be reset )
> 
> The errors, lspci output, and dmesg from both 3G ( broken ) and 1.5G 
> (working) operation are as follows:

Tried a different SATA cable on that drive? The controller is reporting 
SError values and CMD errors, which likely tends to indicate some kind 
of SATA communication problem..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

