Return-Path: <linux-kernel-owner+w=401wt.eu-S1754776AbYFWHrp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776AbYFWHrp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 03:47:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752235AbYFWHrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 03:47:36 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:40142 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722AbYFWHrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 03:47:35 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [Bug #10868] Oops on loading ipaq module since 2.6.26, prevents use of device
Date: Mon, 23 Jun 2008 09:48:01 +0200
User-Agent: KMail/1.9.9
Cc: Adrian Bunk <bunk@kernel.org>, Arjan van de Ven <arjan@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adam Williamson <awilliamson@mandriva.com>, Alan Cox <alan@redhat.com>,
       bugme-daemon@bugzilla.kernel.org
References: <RzbtSgMztjP.A.jRD._spXIB@albercik> <20080622211734.GE20122@cs181140183.pp.htv.fi> <20080622233720.731f696f@lxorguk.ukuu.org.uk>
In-Reply-To: <20080622233720.731f696f@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806230948.03027.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 23 Juni 2008 00:37:20 schrieb Alan Cox:
> > > btw this also shows that this isn't a 2.6.25 regression... 
> > 
> > That hardly shows it.
> > 
> > And Adam said quite explicitely that 2.6.25 worked for him.
> 
> Nothing much I can do to help. The URB is assigned in setup and is NULL
> later. Nothing else I can find touches it.

We need this oops replicated with debug enabled in the usb serial core.

	Regards
		Oliver
