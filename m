Return-Path: <linux-kernel-owner+w=401wt.eu-S1756789AbYEMAYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756789AbYEMAYY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 20:24:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753832AbYEMAYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 20:24:12 -0400
Received: from outbound-mail-110.bluehost.com ([69.89.22.10]:35813 "HELO
	outbound-mail-110.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753192AbYEMAYL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 20:24:11 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: =?utf-8?q?Bj=C3=B6rn_Krombholz?= <fox.box@gmail.com>
Subject: Re: [PATCH] PCI: enable nv_msi_ht_cap_quirk for ALi bridges (2.6.24 regression)
Date: Mon, 12 May 2008 17:24:06 -0700
User-Agent: KMail/1.9.9
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
References: <200805120024.27230.fox.box@gmail.com>
In-Reply-To: <200805120024.27230.fox.box@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200805121724.06625.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, May 11, 2008 3:24 pm Björn Krombholz wrote:
> This applies the NVidia MSI enabled flag for HT capable devices quirk
> to ALi bridges as well.
>
> As described in more detail in
> http://bugzilla.kernel.org/show_bug.cgi?id=10667 this is required for
> my board which is using an nForce 3 250Gb chipset with an ALi M1695
> northbridge.
>
> It fixes a regression introduced in 2.6.24 that made the internal NIC
> of the board unusable (MSI initialisation of the NIC but disabled MSI
> on the northbridge devices.
>
> Signed-off-by: Björn Krombholz <fox.box@gmail.com>
> ---
>
> The patch is trivial but Andrew asked me to send it to the list(s). As
> this is my first report of this kind, please give me a hint on any
> formal mistakes.

Applied to the 'for-linus' tree.  Thanks.

Jesse
