Return-Path: <linux-kernel-owner+w=401wt.eu-S1761771AbXEPMT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761771AbXEPMT0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 08:19:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756872AbXEPMTU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 08:19:20 -0400
Received: from cantor.suse.de ([195.135.220.2]:51184 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756824AbXEPMTU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 08:19:20 -0400
From: Andi Kleen <ak@suse.de>
To: paulmck@linux.vnet.ibm.com
Subject: Re: How to force Kconfig tristate into range n..m?
Date: Wed, 16 May 2007 14:18:48 +0200
User-Agent: KMail/1.9.1
Cc: linux-kernel@vger.kernel.org
References: <20070515233002.GA9614@linux.vnet.ibm.com>
In-Reply-To: <20070515233002.GA9614@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705161418.49151.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 
>
> Is there some other way to prohibit modules from being compiled into
> the main kernel?

One way is to use a separate symbol that is not user visible, but depends
on your main symbol and uses default m

(similar to the now infamous CONFIG_SCSI_WAIT_SCAN)

-Andi
