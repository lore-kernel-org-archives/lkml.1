Return-Path: <linux-kernel-owner+w=401wt.eu-S1759478AbXH1Szf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759478AbXH1Szf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 14:55:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752917AbXH1Sz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 14:55:28 -0400
Received: from host-66-43-248-10 ([67.55.143.10]:35325 "EHLO albrecht.rdi1.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751274AbXH1Sz2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 14:55:28 -0400
Subject: Re: dm-crypt mount returns EINVAL
From: Paul Albrecht <albrecht@rdi1.com>
To: Satyam Sharma <satyam@infradead.org>
Cc: Paul Albrecht <albrecht@rdi1.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.0.999.0708282042210.24588@enigma.security.iitk.ac.in>
References: <1188307465.2653.12.camel@albrecht.rdi1.com>
	 <alpine.LFD.0.999.0708282042210.24588@enigma.security.iitk.ac.in>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 28 Aug 2007 13:59:46 -0400
Message-Id: <1188323986.5357.8.camel@albrecht.rdi1.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-08-28 at 20:45 +0530, Satyam Sharma wrote:
> Hi Paul,
> 
> 
> On Tue, 28 Aug 2007, Paul Albrecht wrote:
> 
> > Hi,
> > 
> > I have recently upgraded my kernel to 2.6.21 from 2.6.20 and that has
> > caused a problem mounting an encrypted partition using dm-crypt.
> > 
> > In my init script, I use cryptsetup to create device which I use to
> > mount an encrypted partition. Since I changed to 2.6.21 the mount fails
> > returning an EINVAL status which doesn't make much sense because the
> > init script is unchanged and works if reverted to 2.6.20.
> > 
> > Any ideas? How can I debug this problem? I'm not subscribed to lkml so
> > please cc in your response.
> 
> What was the error you got from cryptsetup()? Also, please post the
> kernel's dmesg log and the .config of the 2.6.21 kernel (new one).
> 
> Also, compare the .config's of the two kernels and ensure that
> CONFIG_DM_CRYPT (or possibly one of the _CRYPTO_ config options)
> didn't get lost or automatically unset during the upgrade/oldconfig.
> 

Found the problem ... the pass phrase used in cryptsetup is incorrect
for the partition I want to decrypt. Not sure why that is because I
compute it at runtime. One of the parameters I use must have changed
from 2.6.20 to 2.6.21. I'll have to sort that out myself. Thanks
anyways!

Paul Albrecht

