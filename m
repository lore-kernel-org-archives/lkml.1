Return-Path: <linux-kernel-owner+w=401wt.eu-S1754514AbYJURYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754514AbYJURYy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 13:24:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751423AbYJURYo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 13:24:44 -0400
Received: from outbound-mail-06.bluehost.com ([69.89.17.206]:33611 "HELO
	outbound-mail-06.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751074AbYJURYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 13:24:44 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=l1gzgGsBnPXPGlCEajFC02ZWJ12j0sOZNNY+5iYCLtAAIOqyLZSwMyriXVQHbAPFXKWoJC6pyzpy2DdUxVtbPfW+f9jhtARH4HvpfKXkpubPbfAJqAplOwoFcJR3OefL;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] pci: Fixing drivers/pci/search.c compilation warning.
Date: Tue, 21 Oct 2008 10:24:30 -0700
User-Agent: KMail/1.10.1 (Linux/2.6.26.5-45.fc9.x86_64; KDE/4.1.2; x86_64; ; )
Cc: linux-pci@vger.kernel.org, greg@kroah.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       Rakib Mullick <rakib.mullick@gmail.com>
References: <b9df5fa10809280816u23ef3021k7eee287a237b72ae@mail.gmail.com> <20080928163211.GR27204@parisc-linux.org> <20081021011308.GA3889@parisc-linux.org>
In-Reply-To: <20081021011308.GA3889@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810211024.31037.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, October 20, 2008 6:13 pm Matthew Wilcox wrote:
> Subject: [PCI] Fix reference counting bug
>
> pci_get_subsys() will decrement the reference count of the device that
> it starts searching from.  Unfortunately, the pci_find_device() interface
> will already have decremented the reference count of the device earlier,
> so the device will end up losing all reference counts and be freed.
>
> We can fix this by incrementing the reference count of the device to
> start searching from before calling pci_get_subsys().
>
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

Applied, thanks Matthew.

Jesse
