Return-Path: <linux-kernel-owner+w=401wt.eu-S1761310AbYHUWR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761310AbYHUWR1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 18:17:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761166AbYHUWRG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 18:17:06 -0400
Received: from outbound-mail-143.bluehost.com ([67.222.38.33]:52794 "HELO
	outbound-mail-143.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760879AbYHUWRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 18:17:05 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=RZbustYILtRA6XsO3XWnQccksPhPfGWdHFuefufQJgWFPGP/oAgtgcR+ClwEWGJWEuR6HN2SAKjzzuBfOybiuvdpzmUCHU654l6raQOmng7BSWOspx3lOFGYzxiLDJea;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Alex Chiang <achiang@hp.com>
Subject: Re: [PATCH 0/2] pciehp/shpchp prevent duplicate slot names
Date: Thu, 21 Aug 2008 15:16:59 -0700
User-Agent: KMail/1.9.9
Cc: kaneshige.kenji@jp.fujitsu.com, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20080821211137.GB24411@ldl.fc.hp.com>
In-Reply-To: <20080821211137.GB24411@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808211517.00087.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, August 21, 2008 2:11 pm Alex Chiang wrote:
> Hi Jesse,
>
> Here are patches:
>
> 	[PATCH 1/2] pciehp: Rename duplicate slot name N as N-1, N-2, N-M...
> 	[PATCH 2/2] shpchp: Rename duplicate slot name N as N-1, N-2, N-M...
>
> Against Linus's 2.6.27-rc4.
>
> As noted in the changelogs, these are temporary patches, meant as
> placeholders until I complete the longer patch series that allows
> the PCI core to manage the slot names on behalf of the drivers.
>
> The longer patch series will keep the same behavior that these
> temp patches implement, so that's goodness.
>
> These patches have already been tested and acked by Kenji-san.
>
> 	http://article.gmane.org/gmane.linux.kernel/714583
> 	http://article.gmane.org/gmane.linux.kernel/714582
>
> So I think you can add his sign-offs too.

Excellent, thanks Alex & Kenji-san.  I applied this to my for-linus branch.  
I'll have Linus pull it soon.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
