Return-Path: <linux-kernel-owner+w=401wt.eu-S1754042AbYIWSxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042AbYIWSxV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 14:53:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751735AbYIWSxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 14:53:13 -0400
Received: from outbound-mail-139.bluehost.com ([67.222.39.29]:36894 "HELO
	outbound-mail-139.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750982AbYIWSxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 14:53:12 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=s99q8xQBYQoWtpgAOeQb1dK+1kNKCS7BSQi2nkaoojS/pBqGWMqqX6go7F0ORgQ0kUFtRcCxcFoqjYviWeRN4MHiLvefjasaDp5XP9HoLt8Ph8EhPSlV3xESx216fTR5;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 2.6.27-rc6] PCI: Fix pcie_aspm=force
Date: Tue, 23 Sep 2008 11:53:06 -0700
User-Agent: KMail/1.9.9
Cc: Sitsofe Wheeler <sitsofe@yahoo.com>, "Li, Shaohua" <shaohua.li@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <1221571633.4060.19.camel@galvatron> <20080916150851.4f1c8489@lxorguk.ukuu.org.uk>
In-Reply-To: <20080916150851.4f1c8489@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809231153.07167.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, September 16, 2008 7:08 am Alan Cox wrote:
> On Tue, 16 Sep 2008 14:27:13 +0100
>
> Sitsofe Wheeler <sitsofe@yahoo.com> wrote:
> > From: Sitsofe Wheeler <sitsofe@yahoo.com>
> >
> > pcie_aspm=force did not work because aspm_force was being double negated
> > leading to the sanity check failing. Moving a bracket should fix this.
> >
> > Signed-off-by: Sitsofe Wheeler <sitsofe@yahoo.com>
>
> Acked-by: Alan Cox <alan@redhat.com>

Not sure if I already sent you a note, but this is queued up in my for-linus 
branch.  I'll be sending Linus a pull request later today for it.

Thanks,
Jesse
