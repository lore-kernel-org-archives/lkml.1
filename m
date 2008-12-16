Return-Path: <linux-kernel-owner+w=401wt.eu-S1756891AbYLPSvG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756891AbYLPSvG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 13:51:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752578AbYLPSuy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 13:50:54 -0500
Received: from outbound-mail-306.bluehost.com ([67.222.53.252]:44963 "HELO
	outbound-mail-306.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752351AbYLPSuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 13:50:54 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=LrEUtJv2lMdMlNEDybgBO6MYIjZGV+VD6sJhsg3MHDswJL3o5B4JDbHLv/GAQrhHppOrM4/PWsS2cciFtRcTaCJEFVPKHE+ZYDY0etaSnzXI4nd+Pw0N3M40SS8W/dsx;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 1/2] PCI Hotplug: acpiphp wants a 64-bit _SUN
Date: Tue, 16 Dec 2008 10:47:24 -0800
User-Agent: KMail/1.10.1 (Linux/2.6.27.5-41.fc9.x86_64; KDE/4.1.2; x86_64; ; )
Cc: Alex Chiang <achiang@hp.com>, justin.chen@hp.com,
       "linux-pci" <linux-pci@vger.kernel.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>
References: <20081211181242.GD18309@ldl.fc.hp.com> <200812111035.02652.jbarnes@virtuousgeek.org> <20081211190346.GD26095@parisc-linux.org>
In-Reply-To: <20081211190346.GD26095@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812161047.24759.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, December 11, 2008 11:03 am Matthew Wilcox wrote:
> On Thu, Dec 11, 2008 at 10:35:01AM -0800, Jesse Barnes wrote:
> > On Thursday, December 11, 2008 10:16 am Alex Chiang wrote:
> > > From: Justin Chen <justin.chen@hp.com>
> > >
> > > Certain HP machines require the full 64 bits of _SUN as allowed
> > > by the ACPI spec. Without this change, we get name collisions in
> > > the lower 32 bits of the _SUN returned by firmware.
> > >
> > > Signed-off-by: Justin Chen <justin.chen@hp.com>
> > > Signed-off-by: Alex Chiang <achiang@hp.com>
> >
> > It's very late in the cycle, so I'd like to get acks from at least a
> > couple of other testers for this one...  Any volunteers?
>
> Testers or reviewers?  Here's my review (done thinking out loud style):

Well, review is good too; I stuffed this one into my for-linus branch (the 
whitespace one went into linux-next), thanks for checking it out.

-- 
Jesse Barnes, Intel Open Source Technology Center

