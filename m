Return-Path: <linux-kernel-owner+w=401wt.eu-S1756366AbXFXRJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756366AbXFXRJp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 13:09:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751819AbXFXRJg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 13:09:36 -0400
Received: from mcr-smtp-001.bulldogdsl.com ([212.158.248.7]:4697 "EHLO
	mcr-smtp-001.bulldogdsl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751742AbXFXRJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 13:09:35 -0400
X-Spam-Abuse: Please report all spam/abuse matters to abuse@bulldogdsl.com
From: Alistair John Strachan <s0348365@sms.ed.ac.uk>
To: linux-kernel@vger.kernel.org
Subject: Re: Frequent SATA resets with sata_nv (fwd)
User-Agent: KMail/1.9.7
References: <alpine.DEB.0.99.0706232051520.31644@cheetah.fastcat.org>
In-Reply-To: <alpine.DEB.0.99.0706232051520.31644@cheetah.fastcat.org>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 2063
Date: Sun, 24 Jun 2007 18:09:29 +0100
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200706241809.29449.s0348365@sms.ed.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(Sorry, accidentally dropped LKML)

On Sunday 24 June 2007 01:52:30 you wrote:
> Googling around lkml.org, I found a few threads investigating what look
> like very similar problems, some of which never seemed to find the
> solution, but one of which came up with a fairly quick answer it seemed,
> namely that the drive's NCQ implementation was horked:
> http://lkml.org/lkml/2007/4/18/32

Well, there's been generic problems with the ADMA code on the CK804, but I 
think Robert fixed them (added CC). I've certainly had NO problems since 
2.6.21.

However, assuming the drive's NCQ _is_ busted and needs to be blacklisted, you 
might find you can temporarily work around the problem by loading the sata_nv 
module with adma=0, or boot with sata_nv.adma=0. Not to point the finger at 
ADMA support specifically, of course, but simply that ADMA enables the NCQ 
features.

It'd be good if you could report back whether this helps fix it.

> While I don't have older logs to verify exactly when this started, it
> was fairly recent, perhaps around my 2.6.20.1 to 2.6.21.1 kernel
> upgrade.

Yes, this is probably around the time adma became the default.

-- 
Cheers,
Alistair.

Final year Computer Science undergraduate.
1F2 55 South Clerk Street, Edinburgh, UK.
