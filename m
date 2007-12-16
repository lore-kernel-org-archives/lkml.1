Return-Path: <linux-kernel-owner+w=401wt.eu-S1757519AbXLPTZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757519AbXLPTZm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 14:25:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752684AbXLPTZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 14:25:34 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:10350 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259AbXLPTZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 14:25:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=VHg9+cn6tf6HfYS+RTfRSrY99QmZCb5STI7DCxIt9UBtmQSqr30j+f8L19NfsBCzLOoGzjSN877PGdC/RFeBRiG/quPd2MZ7Hj6eI4FfxbRJCTdixQBf1Ow+Rz1ft/czPKkNUup/fa35ezr6hHCE7FtPqZ33Q2qj15gicEZ2q5w=
Message-ID: <47657BA8.3020004@googlemail.com>
Date: Sun, 16 Dec 2007 20:25:28 +0100
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071204)
MIME-Version: 1.0
To: Oliver Joa <oliver@j-o-a.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: How to Switch DMA off for only one Harddisk at Kernelboot
References: <4765690C.6010605@j-o-a.de>
In-Reply-To: <4765690C.6010605@j-o-a.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver Joa wrote:
> Hi,

Hi Oliver ,

> 
> how can I tell the kernel not to probe DMA for a specific harddisk (e.g. 
> hda). My first Drive (hda) is a Compact-Flash Card which can not do DMA. 
> The kernel tries at boot to switch to DMA but fails. If I use ide=nodma, 
> the kernel boots about 2 minutes faster, but then I can not switch on 
> DMA for the second Drive (hdc) which is a normal Harddisk. Do I have to 
> live with this 2 minutes waiting time or is there another solution? I 
> did not find any kernel-parameter for this purpose.
> 
> Sorry if I ask here, but I can not find any solution, and I asked 
> already in other groups.
> 
> Thank you very much

Should work with hda=nodma or ideX=nodma ( where X is your HDD nr , in your case is 0 )

Also have a look at Documentation/ide.txt.

> Olli

Gabriel
