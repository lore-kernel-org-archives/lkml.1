Return-Path: <linux-kernel-owner+w=401wt.eu-S1754175AbYI2S1G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175AbYI2S1G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 14:27:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751974AbYI2S0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 14:26:53 -0400
Received: from outbound-mail-03.bluehost.com ([69.89.21.13]:40797 "HELO
	outbound-mail-03.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751901AbYI2S0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 14:26:50 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=o2F8LDkWjyg0whi2+bPYcPSMZdTAhvzCGglTQ0JRvrWomll0+wzJzx3MrqVXO4S6i02fwIuE6066ZjDAyJH7i75oUARiL55l9jdfd2niEbZ217iyfuYtKwOzpqeSx9GM;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 01/19] pci: introduce an pci_ioremap(pdev, barnr) function
Date: Mon, 29 Sep 2008 11:26:41 -0700
User-Agent: KMail/1.9.9
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Rolf Eike Beer <eike-kernel@sf-tec.de>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
References: <20080928163611.3df8a9e0@infradead.org> <20080929184519.11d08dc4@lxorguk.ukuu.org.uk> <20080929111558.04f27eea@infradead.org>
In-Reply-To: <20080929111558.04f27eea@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809291126.42753.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, September 29, 2008 11:15 am Arjan van de Ven wrote:
> On Mon, 29 Sep 2008 18:45:19 +0100
>
> Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > > > This is the same like pci_iomap(pdev, number, 0), no?
> > >
> > > Yeah... Looks like that function isn't that widely used though.  Is
> > > the maxlen param really needed?  Looks like the drivers that use it
> > > often pass 0 or the
> >
> > In some cases yes you do need the length.
>
> so we should have a 2nd api for those "some cases", that's ok.

Right, I'm definitely not suggesting that we don't provide a way to provide 
length, but if 90+% of callers don't need it, we should probably have a 
simpler API that does the bare minimum.

Jesse
