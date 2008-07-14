Return-Path: <linux-kernel-owner+w=401wt.eu-S1758044AbYGNVbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758044AbYGNVbR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 17:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756834AbYGNVbF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 17:31:05 -0400
Received: from outbound-mail-30.bluehost.com ([69.89.17.212]:38956 "HELO
	outbound-mail-30.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756438AbYGNVbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 17:31:04 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User:DomainKey-Status;
	b=it46fDTQHe5/IbLOa5WfAiYeEun3JjK3Cg9pmfrdZa1eClQuhvorDxxwpFmvN0aqeu9m+UTeo7u91maT9obwtZeL4jwPVQou+lTppG1hUn0UgP3GYWZfIu0uznyC6YDM;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: next-0708: build failure at drivers/pci/pci-acpi.c
Date: Mon, 14 Jul 2008 14:30:36 -0700
User-Agent: KMail/1.9.9
Cc: "Alexander Beregalov" <a.beregalov@gmail.com>, ak@linux.intel.com,
       lenb@kernel.org, linux-acpi@vger.kernel.org, linux-next@vger.kernel.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "pm list" <linux-pm@lists.linux-foundation.org>,
       David Howells <dhowells@redhat.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>
References: <a4423d670807080518g31402f60j2f624a2ac2db03aa@mail.gmail.com> <200807091621.37697.jbarnes@virtuousgeek.org> <200807100216.45690.rjw@sisk.pl>
In-Reply-To: <200807100216.45690.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807141430.36926.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 09, 2008 5:16 pm Rafael J. Wysocki wrote:
> On Thursday, 10 of July 2008, Jesse Barnes wrote:
> > On Tuesday, July 8, 2008 1:29:31 pm Rafael J. Wysocki wrote:
> > > On Tuesday, 8 of July 2008, Jesse Barnes wrote:
> > > > David sent me one just like this at 7am this morning, just applied
> > > > and pushed (along with Alexander's tested-by).
> > >
> > > OK, thanks.
> > >
> > > Would you like me to send the Stephen's fix for compilation on ppc64
> > > (CONFIG_PM unset)?
> >
> > Sure, unless it's already in the ppc tree...
>
> It looks like Stephen had to apply it today too, so I guess it isn't.
>
> Thanks,
> Rafael
>
> ---
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Subject: [PATCH] pci: include linux/pm_wakeup.h for
> device_set_wakeup_capable
>
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Applied to my linux-next branch, thanks.

Jesse
