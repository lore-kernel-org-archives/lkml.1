Return-Path: <linux-kernel-owner+w=401wt.eu-S964828AbXCLAOF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964828AbXCLAOF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 20:14:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964817AbXCLAOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 20:14:05 -0400
Received: from usul.saidi.cx ([204.11.33.34]:39343 "EHLO usul.overt.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S964828AbXCLAOE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 20:14:04 -0400
Message-ID: <45F49B28.7090609@overt.org>
Date: Sun, 11 Mar 2007 17:13:28 -0700
From: Philip Langdale <philipl@overt.org>
Reply-To: philipl@alumni.utexas.net
User-Agent: Thunderbird 1.5.0.7 (X11/20060909)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-list@drzeus.cx>
CC: LKML <linux-kernel@vger.kernel.org>,
       Carlos Aguiar <carlos.aguiar@indt.org.br>, juha.yrjola@solidboot.com
References: <45F33C2C.2090905@overt.org> <45F4934A.3030303@drzeus.cx>
In-Reply-To: <45F4934A.3030303@drzeus.cx>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] MMC: Clean up low voltage range handling
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman wrote:
> 
> We must not have the same specs. My simplified SD 2.0 physical spec
> defines everything below bit 15 as reserved.

I was a little unclear. Both specs define bit 7 as the low-voltage
range but only the MMC spec defines the actual voltage. As such, there
is no complete definition of a low voltage SD card. That's why I added
the sanity check in the actual code.

> Although this is a nice change, it confuses things to have two changes
> in one commit. Could you split them up and base it on my "for-andrew"
> branch?

Yeah, I thought you'd think that :-) I'll post the two diffs shortly.

Thanks,

--phil
