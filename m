Return-Path: <linux-kernel-owner+w=401wt.eu-S1758320AbZBXQo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758320AbZBXQo1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 11:44:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756678AbZBXQoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 11:44:18 -0500
Received: from outbound-mail-43.bluehost.com ([69.89.18.12]:40683 "HELO
	outbound-mail-43.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754786AbZBXQoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 11:44:18 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=ZouMjn0CaK6TcUasjRfn+w7H1Xt0voLyz6ui/NH8kP8DyqBdjN9E08mSG9jtzSxcolWUy0uzfMaI2dEOKHhQw+7t/EObFy/nyHRy0eYtSpXc1om6pBaUsvNdzYb+CnJe;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: [REGRESSION] i915 VT switch with AIGLX causes X lock up
Date: Tue, 24 Feb 2009 08:44:09 -0800
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; x86_64; ; )
Cc: dri-devel@lists.sf.net, LKML <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Eric Anholt <eric@anholt.net>
References: <20090221153822.GA4571@silver.sucs.org> <20090223223226.GA23763@silver.sucs.org>
In-Reply-To: <20090223223226.GA23763@silver.sucs.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902240844.09424.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, February 23, 2009 2:32:26 pm Sitsofe Wheeler wrote:
> On Sat, Feb 21, 2009 at 03:38:22PM +0000, Sitsofe Wheeler wrote:
> > With 2.6.29rc5 and xorg-server 2:1.4.1~git20080131-1ubuntu9.2 switching
> > to a VT after starting compiz causes X to nearly lock up.
> >
> > Steps to reproduce:
> > 1. Start X
> > 2. Run compiz
> > 3. Switch to VT1 via ctrl-alt-f1
> > 4. Switch back to X via ctrl-alt-f7
> >
> > The result is that X will remain displaying a black screen from then on
> > (the mouse cursor is visible and still moves). Switching to a VT after
> > this locks up the keyboard. When compiz is not running this bug does not
> > occur. I am not using kernel mode setting and booting with nomodesetting
> > made no difference. This problem was not present in 2.6.28. The problem
> > is reproducible every time.
> >
> > Graphics card is an i915 in an EeePC 900:
> >
> > 00:02.0 VGA compatible controller [0300]: Intel Corporation Mobile
> > 915GM/GMS/910GML Express Graphics Controller [8086:2592] (rev 04)
> >
> > This might be http://bugzilla.kernel.org/show_bug.cgi?id=12264 but I
> > can't reopen that bug and this bug might turn out to be different. Might
> > also be related to
> > http://marc.info/?l=linux-kernel&m=123499984611624&w=2 .
>
> Still here in 2.6.29-rc6.

Can you get a backtrace of the hung process, maybe by logging in from another 
machine and using gdb on the Xorg process?
-- 
Jesse Barnes, Intel Open Source Technology Center
