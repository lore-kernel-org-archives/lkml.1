Return-Path: <linux-kernel-owner+w=401wt.eu-S1756044AbYGCTH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044AbYGCTH2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 15:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752673AbYGCTHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 15:07:16 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:33158 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145AbYGCTHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 15:07:15 -0400
Date: Thu, 3 Jul 2008 21:07:13 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Jens-Michael Hoffmann <J.Hoffmann@option.com>,
       linux-kernel@vger.kernel.org
Subject: Re: tcp/ip connect on demand
In-Reply-To: <486D1A66.6010006@zytor.com>
Message-ID: <alpine.LNX.1.10.0807032106310.23294@fbirervta.pbzchgretzou.qr>
References: <F67862BE33DC784289A6B34E92908FCF393FFE@SRV-SATURNUS.OPTION.local> <486D1A66.6010006@zytor.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thursday 2008-07-03 20:28, H. Peter Anvin wrote:
> Jens-Michael Hoffmann wrote:
>> hi,
>> 
>> what is the right way to implement a "connect on demand" feature?
>> Example: user types url in firefox and presses return. Then
>> the system should set up network devices and proceed as usual.
>> 
>> Is there a hook in the kernel we can use?
>
> In the kernel, no.  Nor do you need one; the best place to hook into this is
> probably the name service system (so you catch it on trying to look up
> hostnames.)
>
> Alternatively, you can set up a bridge device which you can listen to via a tap
> device; when you see traffic, you bring up the real network and attach it to
> the bridge.

There is on-demand for PPP devices; though that is probably specific
to PPP.
