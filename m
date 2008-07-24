Return-Path: <linux-kernel-owner+w=401wt.eu-S1753715AbYGXULj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715AbYGXULj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 16:11:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751926AbYGXULa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 16:11:30 -0400
Received: from outbound-mail-20.bluehost.com ([69.89.20.235]:49659 "HELO
	outbound-mail-20.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751244AbYGXULa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 16:11:30 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=MIHnZUwEbSanWtuLhgAXJKoWRxfWdyMa1YIEKoVmmcehte/vXvwolfrll4R7x3gVFP/aWqqFmERfJBArRRWU5Hb4VHxsNq4rGviy8XccSGYgBzy5ztbBG9kRzVYNOEwa;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH PROPOSAL] libata/pci: Move D3 hack handling from libata into PCI
Date: Thu, 24 Jul 2008 13:11:24 -0700
User-Agent: KMail/1.9.9
Cc: jeff@garzik.org, greg@kroah.com, linux-kernel@vger.kernel.org
References: <20080724171838.591f6a31@lxorguk.ukuu.org.uk>
In-Reply-To: <20080724171838.591f6a31@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807241311.24384.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 24, 2008 9:18 am Alan Cox wrote:
> Libata has some hacks to deal with certain controllers going silly in D3
> state. The right way to handle this is to keep a PCI device flag for such
> devices. That can then be generalised for no ATA devices with power
> problems.
>
> Signed-off-by: Alan Cox <alan@redhat.com>

Looks pretty reasonable to me; do you want me to take the drivers/ata bits 
along with the PCI stuff?

Btw, what happens to these devices in D3hot?  Do they behave like they're in 
D3cold or something and require a reset?  Or do they otherwise kill the bus 
somehow?

Thanks,
Jesse
