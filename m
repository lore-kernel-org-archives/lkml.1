Return-Path: <linux-kernel-owner+w=401wt.eu-S1758625AbXGDVNy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758625AbXGDVNy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 17:13:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751803AbXGDVNq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 17:13:46 -0400
Received: from main.gmane.org ([80.91.229.2]:55050 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755048AbXGDVNp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 17:13:45 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Thomas Backlund <tmb@mandriva.org>
Subject: Re: speed trends in pata world.
Date: Thu, 05 Jul 2007 00:13:50 +0300
Message-ID: <f6h2ho$b44$1@sea.gmane.org>
References: <200707041550.22533.gene.heskett@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: ndn243.bob.fi
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
In-Reply-To: <200707041550.22533.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gene Heskett skrev:
> Greetings;
> 
> The drive speeds seem to be going the wrong way.  Its an nforce2 equipt mobo, 
> and I have 3 drives currently in this box.  Running 2.6.22-rc6-cfs-v18 + the 
> ftdi_sio.c patch.
> 
> hda, the primary on cable 0, is running at around 28MB/Sec.  Its a 200GB WD 
> about 2 years old.
> 

Looks like this one is stuck at UDMA/33

Check the dmesg what the kernel detects, and why it ends up at low speed...

> hdb, is running at around 79MB/Sec, its a 4 year old 120GB WD.
> hdd is running at about 75MB/Sec, is a nearly new 300GB WD.
> 
> Can I read anything into the fact that the 2 fast drives are on the slave end 
> of the cables, whereas the slow one is master in the middle of the cable?
> 

--
Thomas

