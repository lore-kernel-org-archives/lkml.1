Return-Path: <linux-kernel-owner+w=401wt.eu-S1756304AbYIPQTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756304AbYIPQTT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 12:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754698AbYIPQTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 12:19:12 -0400
Received: from outbound-mail-06.bluehost.com ([69.89.17.206]:58146 "HELO
	outbound-mail-06.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754208AbYIPQTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 12:19:11 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=I702AD8Tr5w6EjpSMgD9TIFP/kz22uaEvJ/jZqjAkVYp0QFqJNWZdxR36sKVNaykNSte+/RAbn0jr0vLWSJXVkysYDQgR0Tk4dIAvspr5nvjqe0DuA838YLmclw4gCL2;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: [PATCH 2.6.27-rc6] PCI: Fix pcie_aspm=force
Date: Tue, 16 Sep 2008 09:19:07 -0700
User-Agent: KMail/1.9.9
Cc: "Li, Shaohua" <shaohua.li@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <1221571633.4060.19.camel@galvatron>
In-Reply-To: <1221571633.4060.19.camel@galvatron>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809160919.07958.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 131.252.246.160 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, September 16, 2008 6:27 am Sitsofe Wheeler wrote:
> From: Sitsofe Wheeler <sitsofe@yahoo.com>
>
> pcie_aspm=force did not work because aspm_force was being double negated
> leading to the sanity check failing. Moving a bracket should fix this.
>
> Signed-off-by: Sitsofe Wheeler <sitsofe@yahoo.com>

Thanks, I applied this to my for-linus branch so we can try to get this fixed 
for 2.6.27.

Jesse
