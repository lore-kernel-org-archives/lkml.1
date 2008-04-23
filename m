Return-Path: <linux-kernel-owner+w=401wt.eu-S1755020AbYDWWqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020AbYDWWqV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 18:46:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751937AbYDWWqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 18:46:14 -0400
Received: from outbound-mail-123.bluehost.com ([67.222.38.23]:41866 "HELO
	outbound-mail-123.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751808AbYDWWqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 18:46:13 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Shaohua Li <shaohua.li@intel.com>
Subject: Re: [PATCH] PCI Express ASPM support should default to 'No'
Date: Wed, 23 Apr 2008 15:46:06 -0700
User-Agent: KMail/1.9.9
Cc: Jesper Juhl <jesper.juhl@gmail.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>
References: <alpine.LNX.1.00.0804230024210.14359@dragon.funnycrock.com> <200804221712.45972.jbarnes@virtuousgeek.org> <1208912721.31625.3.camel@sli10-desk.sh.intel.com>
In-Reply-To: <1208912721.31625.3.camel@sli10-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804231546.07172.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 131.252.210.190 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 22, 2008 6:05 pm Shaohua Li wrote:
> On Tue, 2008-04-22 at 17:12 -0700, Jesse Barnes wrote:
> > On Tuesday, April 22, 2008 3:28 pm Jesper Juhl wrote:
> > > Running 'make oldconfig' I just noticed that PCIEASPM defaults to
> > > 'y' in Kconfig even though the feature is both experimental and the
> > > help text recommends that if you are unsure you say 'n'.
> > > It seems to me that this really should default to 'n', not 'y' at the
> > > moment.
> > > The following patch makes that change. Please consider applying.
> >
> > Seem reasonable, Shaohua?  Please cc linux-pci on PCI patches
> > though...
>
> Ok, I'm fine with the patch. Though by default, the policy is to use
> BIOS setting, that is if BIOS disables ASPM, we don't enable it too.

Ok, pushed.  Thanks Jesper & Shaohua.

Jesse
