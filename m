Return-Path: <linux-kernel-owner+w=401wt.eu-S1751838AbYKCWiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751838AbYKCWiV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 17:38:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752251AbYKCWiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 17:38:12 -0500
Received: from outbound-mail-133.bluehost.com ([67.222.39.23]:43096 "HELO
	outbound-mail-133.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751353AbYKCWiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 17:38:11 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=r26tRIz7zmIJXjdhptZ/gwVfAf0InAdCiKY1Q7Vc5+vIc6/+S2Y4IN5fwkaJwPl8HfqWW4oqSID11lwGEtLQMBtKO4ZLPXJI2X36lm7qhljnLBHk/9iQz+0DF0s3j2Yf;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yu Zhao <yu.zhao@intel.com>
Subject: Re: [PATCH] PCI: Limit VPD length for Broadcom 5708S
Date: Mon, 3 Nov 2008 14:37:57 -0800
User-Agent: KMail/1.10.1 (Linux/2.6.26.5-45.fc9.x86_64; KDE/4.1.2; x86_64; ; )
Cc: Eric Dumazet <dada1@cosmosbay.com>, benli@broadcom.com,
       "willy@linux.intel.com" <willy@linux.intel.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Linux Netdev List <netdev@vger.kernel.org>,
       Michael Chan <mchan@broadcom.com>
References: <48920413.6080508@cosmosbay.com> <4906AF5F.9040704@cosmosbay.com> <20081028064411.GA7043@yzhao12-linux.sh.intel.com>
In-Reply-To: <20081028064411.GA7043@yzhao12-linux.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811031437.57997.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, October 27, 2008 11:44 pm Yu Zhao wrote:
> VPD quirks needs to be called after the capability is initialized. Since
> VPD initialization is move to after pci_fixup_header, VPD quirks should
> be done at pci_fixup_final stage correspondingly.
>
> Signed-off-by: Yu Zhao <yu.zhao@intel.com>

Thanks Yu.  Applied to my for-linus branch.  Looks like that was the only 
affected quirk.

Jesse
