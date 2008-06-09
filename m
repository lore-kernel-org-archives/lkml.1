Return-Path: <linux-kernel-owner+w=401wt.eu-S1758942AbYFIJSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758942AbYFIJSS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 05:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758075AbYFIJSA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 05:18:00 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:59281 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758013AbYFIJR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 05:17:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=l3Q/KK9fsvOXuReJPE5leZO2s/fCwtOecG8Gx2VHet+7o6bxdOK1Wa8WghMyVtwDnY
         2e8XL1+RvOjBxx23p6l2C2ohNrBABJsBsf154R75Rd4M+vet/slP9+XO2JskXymOGF1L
         gmtnU78GC5Kkzfjesw5NxKdNHPhUOFRFAIcEM=
Message-ID: <484CF531.30804@gmail.com>
Date: Mon, 09 Jun 2008 18:17:37 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Peer Chen <pchen@nvidia.com>
CC: "Hemmann, Volker Armin" <volker.armin.hemmann@tu-clausthal.de>,
       Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, Kuan Luo <kluo@nvidia.com>
Subject: Re: 2.6.24.X: SATA/AHCI related boot delay. - not with 2.6.24.3
References: <200803091922.33083.volker.armin.hemmann@tu-clausthal.de> <200805291654.03617.volker.armin.hemmann@tu-clausthal.de> <483F804F.1@gmail.com> <200805301243.39751.volker.armin.hemmann@tu-clausthal.de> <4840A085.2080101@gmail.com> <15F501D1A78BD343BE8F4D8DB854566B2AA19253@hkemmail01.nvidia.com>
In-Reply-To: <15F501D1A78BD343BE8F4D8DB854566B2AA19253@hkemmail01.nvidia.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peer Chen wrote:
> I think it did support NCQ function, our windows driver doesn't check
> that capability bit, so it can issue FP-DMA command no matter that bit
> being set or not.

Ah.. okay.  I see.

> For the MSI issue, I suggest just disable the MSI for MCP65 ahci
> controller, it should be hardware bug. More specifically, you can
> disable the MSI if the MCP65 ahci controller's revision ID is 0xa1 or
> 0xa2.

Okay.  I'll prep a patch for the above two issues.

> What's 64bit problem?

Hmmmm.. What was it?  Searching...  Hmmm... Anyone knows what I was
talking about?  :-)  I'll ask again when I recall.

Thanks.

-- 
tejun
