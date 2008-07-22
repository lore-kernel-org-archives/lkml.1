Return-Path: <linux-kernel-owner+w=401wt.eu-S1755832AbYGVV1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755832AbYGVV1Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 17:27:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753314AbYGVV1A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 17:27:00 -0400
Received: from outbound-mail-16.bluehost.com ([69.89.20.231]:45052 "HELO
	outbound-mail-16.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753241AbYGVV07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 17:26:59 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=MHjOnxBRAztMnwcBNS22I+YHMq+IWXUUsy47TWeTLR+kgPlOLHsBhffA2h1HzrsnMp12VqaMmMDh4w7K3qshN8+dNT4RPjPaS2eFTM5bgu6czy63g6MlwB3Ya+B5VPVa;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 2/4] PCI PM: Make more PCI PM core functionality available to drivers
Date: Tue, 22 Jul 2008 14:26:42 -0700
User-Agent: KMail/1.9.9
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>,
       pm list <linux-pm@lists.linux-foundation.org>, netdev@vger.kernel.org,
       Stephen Hemminger <shemminger@vyatta.com>,
       Randy Dunlap <rdunlap@xenotime.net>
References: <200807191436.40726.rjw@sisk.pl> <200807191439.25371.rjw@sisk.pl>
In-Reply-To: <200807191439.25371.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807221426.42725.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, July 19, 2008 5:39 am Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
>
> Make more PCI PM core functionality available to drivers
>
> * Export pci_pme_capable() so that it can be called directly by
>   drivers (for example, tg3 needs that).
>
> * Move the state choosing part of pci_prepare_to_sleep() to a
>   separate function, pci_target_state(), that can be called directly
>   by drivers (for example, tg3 needs that).
>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Applied to for-linus.  I had to fix things up in light of the kdoc fixes Randy 
sent, but I think I got them right.

Thanks,
Jesse
