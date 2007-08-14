Return-Path: <linux-kernel-owner+w=401wt.eu-S1764765AbXHNPm4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764765AbXHNPm4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 11:42:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762041AbXHNPmn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 11:42:43 -0400
Received: from smtp116.sbc.mail.re3.yahoo.com ([66.196.96.89]:33855 "HELO
	smtp116.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757452AbXHNPml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 11:42:41 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:Received:Date:From:To:Subject:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=FqlOdqf9g2x9EJw++Iq9k5yapGKWrC8pXLz6DPxRCGnyy8oi/cDK7k56dIvtAamcqxGYCIRk4XDEdf/PdCKWyoq46xc+BEVYbokgOHMWYICfX2ewKmPjOCnhKpG4UnwUJ7QkHga1UD0ZATYGIC/C1rwQ2u97A15UEuGfUfbTCz0=  ;
X-YMail-OSG: HxcSh1EVM1kInQMk2l226bubx64cEKDpF7O12p7M43n1dIgGfwOjNHA4wN5.GhBvsgye2amk5A--
Date: Tue, 14 Aug 2007 08:42:37 -0700
From: David Brownell <david-b@pacbell.net>
To: webmaster@dragonslave.de
Subject: Re: EHCI Regression in 2.6.23-rc2
Cc: Stuart_Hayes@dell.com, linux-usb-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, jikos@jikos.cz, greg@kroah.com
References: <200708101045.57166.dex@dragonslave.de>
 <200708140843.42196.webmaster@dragonslave.de>
 <200708140101.19651.david-b@pacbell.net>
 <200708141146.43215.webmaster@dragonslave.de>
In-Reply-To: <200708141146.43215.webmaster@dragonslave.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20070814154237.DF0FB2350CA@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> ehci_hcd 0000:00:10.4: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
>
> Build into:
> 00:01.0 PCI bridge: VIA Technologies, Inc. VT8237 PCI bridge [K8T800/K8T890 
> South]

Yeah, VT8235 was their first southbridge with integrated EHCI.
ISTR that the VT8237 worked a bit more smoothly.

I think 8237 was about where they forked off the the VT6212 as
their first discrete EHCI (for addon cards) claiming EHCI 1.0
conformance.  Too bad they didn't recycle all the VT6202 chips
in their inventory at that time...

Now ... are you reporting that this worked with Stuart's patch?
Or that it didn't?  Or that you couldn't say?

- Dave

