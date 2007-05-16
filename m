Return-Path: <linux-kernel-owner+w=401wt.eu-S1761642AbXEPPgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761642AbXEPPgr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 11:36:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757637AbXEPPgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 11:36:41 -0400
Received: from wr-out-0506.google.com ([64.233.184.232]:3818 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757466AbXEPPgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 11:36:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JJiKuElzBsIu0ml+UaMnZ6VNnRr14mjCPbbpwC2jm8ZPqiYE1jHvib2rBFuqPsjLMGxuVAQYeFvs/diToYexcspnS8ozKY4n27xcGWFRNuqHSCDWp4XwQPd9KPFYot1JbtOgZvEde+Xdp+dIYEHev45PJlxK1fSWATccMRFP/+8=
Message-ID: <a781481a0705160836g8287b02p167de29ed9e715ed@mail.gmail.com>
Date: Wed, 16 May 2007 21:06:39 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
Subject: Re: How to force Kconfig tristate into range n..m?
Cc: "Andi Kleen" <ak@suse.de>, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <464B1594.3050407@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070515233002.GA9614@linux.vnet.ibm.com>
	 <200705161418.49151.ak@suse.de> <464B1594.3050407@s5r6.in-berlin.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/16/07, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> Andi Kleen wrote:
> > One way is to use a separate symbol that is not user visible,

Gargle ... gargle ...

> > but depends on your main symbol
> > and uses default m

Aargh!

Please don't recommend such a hack.

[ Note to LKML archive readers: Andi never said this, you never read this. ]

> > (similar to the now infamous CONFIG_SCSI_WAIT_SCAN)
>
> Actually CONFIG_SCSI_WAIT_SCAN should be visible and restricted to m or
> n. :-)

Actually, SCSI_WAIT_SCAN doesn't want to be a separate module in the
first place :-)
