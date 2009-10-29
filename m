Return-Path: <linux-kernel-owner+w=401wt.eu-S1752960AbZJ2MqF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960AbZJ2MqF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 08:46:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752793AbZJ2MqE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 08:46:04 -0400
Received: from mail-bw0-f227.google.com ([209.85.218.227]:46576 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656AbZJ2MqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 08:46:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=AQoYF8/jD9w+XsTcYMp6bkfuAWcEmcy+m3FkKTq2kQge+//Mu+GI1FizMAsnRhIaRk
         JL2F+zyP7snyo59VE4dlitK2dph4fT2lDoVuO+UhwTMr1GYgY0q7SKM9jToMWU9L4NHj
         4qCidqK27R5yz3bnLLiaEysUctJpBPTw1aOh4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: David Miller <davem@davemloft.net>
Subject: Re: pull request: wireless-next-2.6 2009-10-28
Date: Thu, 29 Oct 2009 13:45:05 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-96.fc12.x86_64; KDE/4.3.2; x86_64; ; )
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, linville@tuxdriver.com
References: <20091028211031.GF2856@tuxdriver.com> <200910291212.41656.bzolnier@gmail.com> <20091029.051509.119751790.davem@davemloft.net>
In-Reply-To: <20091029.051509.119751790.davem@davemloft.net>
MIME-Version: 1.0
Message-Id: <200910291345.05888.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 October 2009 13:15:09 David Miller wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Date: Thu, 29 Oct 2009 12:12:41 +0100
> 
> > What is even more disappointing (especially after all that "working with"
> > preaching) is that the patch is now in net-next-2.6..
> 
> John is the wireless maintainer, I take his tree in since the changes
> in there have his blessing.
> 
> If you have a problem with some change in there, work it out with him
> and he'll send the fixed up changes to me thereafterwards.

What do you mean by that?

That *I* should be fixing the patch in question instead of the submitter?

Do some different rules apply in the networking than in other parts of
the kernel that I'm not aware of?

There were valid concerns raised on the initial rt2800pci patch submission,
yet two days later patch is in John's tree, after few more days it is in yours
tree and happily on his way into 2.6.33.

Until issues mentioned in:

	http://lkml.org/lkml/2009/10/17/81

are addressed rt2800pci shouldn't be queued for Linus' tree.

[ Please note that this driver doesn't work at all currently so the standard
  argument of having hardware support early upstream cannot be applied here. ]

--
Bartlomiej Zolnierkiewicz
