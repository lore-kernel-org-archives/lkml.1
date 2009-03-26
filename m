Return-Path: <linux-kernel-owner+w=401wt.eu-S1762013AbZCZXJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762013AbZCZXJm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 19:09:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755118AbZCZXJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 19:09:29 -0400
Received: from outbound-mail-144.bluehost.com ([67.222.38.34]:45131 "HELO
	outbound-mail-144.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752786AbZCZXJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 19:09:28 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=PSYvflnuCc67pE3g26pUud2aP7B0hTRJJv2r40D9+5PvNcB3qnSTC5XYKb98fx85CGpvj7p1nUa1SHJ2vB5SUq3YcnjRCgLQ6iBToXtHE/pHsHgbxsvQPQtp/D6/6DFW;
Date: Thu, 26 Mar 2009 16:09:24 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86/pci: make pci=lastbus=255 work when acpi is on
Message-ID: <20090326160924.07e42bc0@hobbes>
In-Reply-To: <49CA9365.9090003@kernel.org>
References: <49CA9365.9090003@kernel.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Mar 2009 13:26:13 -0700
Yinghai Lu <yinghai@kernel.org> wrote:

> 
> Impact: scan more peer root buses even acpi is used
> 
> move out pci_bios_fixup_peer_bridges of pci_legacy_init.
> so pci_bios_fixup_peer_bridges could be called even pci_apci_init is
> called.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

Applied, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
