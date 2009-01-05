Return-Path: <linux-kernel-owner+w=401wt.eu-S1753825AbZAERsZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825AbZAERsZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 12:48:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752189AbZAERsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 12:48:17 -0500
Received: from outbound-mail-315.bluehost.com ([67.222.54.8]:43557 "HELO
	outbound-mail-315.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751949AbZAERsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 12:48:16 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=bRS+fAFw+vGU791aMP1n51KZLgpvnZ95tPor8IstzqYdwLjCw6JE+2fe3BOTGDg13u/15U3iOdI1wKlxFCGGs/yRok1so5HKnypUkwim3N5m4l6sxBIjnzGe6kJAk4hJ;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Regression] X server doesn't start on MSI Wind w/ current mainline
Date: Mon, 5 Jan 2009 09:48:13 -0800
User-Agent: KMail/1.10.1 (Linux/2.6.27.9-73.fc9.x86_64; KDE/4.1.3; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Dave Airlie <airlied@gmail.com>
References: <200901031328.40574.rjw@sisk.pl> <200901050011.32974.rjw@sisk.pl>
In-Reply-To: <200901050011.32974.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901050948.14352.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, January 4, 2009 3:11 pm Rafael J. Wysocki wrote:
> On Saturday 03 January 2009, Rafael J. Wysocki wrote:
> > Hi,
> >
> > With the current mainline and the linux-next branch of your pci-2.6 tree
> > on top, the X server doesn't start any more on MSI Wind (Intel hardware)
> > w/ openSUSE 11.1 .
> >
> > I also tested the linux-next branch of the pci-2.6 tree on top of 2.6.28
> > and it doesn't cause any problem with the X server to happen.
>
> Well, I pulled the mainline from today, unsetted DRM_I915_KMS and it works
> again.
>
> BTW, what user land is necessary for the KMS to work?

Ah yeah defaulting to KMS enabled will probably get you undesirable results at 
this point.  You'll need a bleeding edge 2D driver (from xf86-video-intel git) 
and libdrm 2.4.3 to make this all work.  Be sure to pass "--enable-kms" when 
you configure your 2D driver.

-- 
Jesse Barnes, Intel Open Source Technology Center

