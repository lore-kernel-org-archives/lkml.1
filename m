Return-Path: <linux-kernel-owner+w=401wt.eu-S1760968AbYCSXtF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760968AbYCSXtF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 19:49:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762626AbYCSWRo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 18:17:44 -0400
Received: from outbound-mail-04.bluehost.com ([69.89.21.14]:48205 "HELO
	outbound-mail-04.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S940249AbYCSWRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 18:17:37 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Bryce Harrington <bryce@canonical.com>
Subject: Re: [Regression: 2.6.25-rc5: Blank Screen: Intel 945]
Date: Tue, 18 Mar 2008 14:17:34 -0700
User-Agent: KMail/1.9.9
Cc: Justin Madru <jdm64@gawab.com>, lkml <linux-kernel@vger.kernel.org>
References: <47D828BB.2000702@gawab.com> <200803181300.39857.jbarnes@virtuousgeek.org> <20080318211450.GU7206@bryceharrington.org>
In-Reply-To: <20080318211450.GU7206@bryceharrington.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803181417.34320.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, March 18, 2008 2:14 pm Bryce Harrington wrote:
> On Tue, Mar 18, 2008 at 01:00:39PM -0700, Jesse Barnes wrote:
> > > I could get it to build by ifdefing out th pci_device_map_range call,
> > > and then adding -lpciaccess to the linker, however it segfaults without
> > > that call.
> > >
> > > Does LIBPCIACCESS require xserver 1.4?  (We have 1.3 in Hardy).
>
> (Obviously I meant 1.5 / 1.4 above.  Dah.)
>
> > No, libpciaccess should be standalone, but the Intel driver requires 0.10
> > or better... Which version are you building against?
>
> I've put in a sync request for this to get updated for hardy.  (It still
> will only be in universe, so won't be built automatically with -intel,
> but at least users will be able to more easily compile it by hand.)
>
> Meanwhile, here is a Ubuntu Hardy build of Debian's package:
>
>  
> http://people.ubuntu.com/~bryce/Testing/libpciaccess/libpciaccess-dev_0.10-
>1_i386.deb
> http://people.ubuntu.com/~bryce/Testing/libpciaccess/libpciaccess0_0.10-1_i
>386.deb

Thanks a lot Bryce, hopefully this will help Justin build the register dumper 
so we can track down his problem...

Jesse
