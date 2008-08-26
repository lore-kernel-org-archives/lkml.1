Return-Path: <linux-kernel-owner+w=401wt.eu-S1758590AbYHZQIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758590AbYHZQIU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 12:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756496AbYHZQIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 12:08:12 -0400
Received: from outbound-mail-14.bluehost.com ([69.89.18.114]:54541 "HELO
	outbound-mail-14.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756056AbYHZQIL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 12:08:11 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=b18GhBGz3Yh/g8Iq19J7K1KvyMHex8jA+pQeVlUaS/WxOF1HaYq6OgmjGsIpR1OBKWzQyx+jy0Ef9n3OADSFRD4sfahI0gGEgJxmpd5/ugo/wG7Im7Dg8vebnf0hudJ5;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Greg KH <gregkh@suse.de>
Subject: Re: [2.6.27-rc4-git4] compilation warnings
Date: Tue, 26 Aug 2008 09:08:07 -0700
User-Agent: KMail/1.9.9
Cc: Rufus & Azrael <rufus-azrael@numericable.fr>,
       Linux-kernel Mailing List <linux-kernel@vger.kernel.org>
References: <48B3CEEA.90400@numericable.fr> <20080826152034.GA6593@suse.de>
In-Reply-To: <20080826152034.GA6593@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200808260908.07982.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, August 26, 2008 8:20 am Greg KH wrote:
> On Tue, Aug 26, 2008 at 11:37:46AM +0200, Rufus & Azrael wrote:
> > Hello all,
> >
> > Fresh 2.6.27-rc4-git4 causes these compilation warnings on my amd64 box
> > with gcc-4.3.1 :
> >
> > drivers/pci/search.c: In function ‘pci_get_dev_by_id’:
> > drivers/pci/search.c:284: attention : passing argument 1 of
> > ‘pci_dev_put’ discards qualifiers from pointer target type
> >
> > following this commit : ebca4f1bce1eb7b91a63c515db66316db9391221 PCI: fix
> > reference leak in pci_get_dev_by_id()
>
> Ick, sorry about that, I said my fix was not even build tested :)
>
> Here's a fix for this, Jesse, care to forward this on?

Yeah, thanks Greg.  Alex and I built & booted it, but obviously I missed the 
warning.

Jesse
