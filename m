Return-Path: <linux-kernel-owner+w=401wt.eu-S1755633AbZHKXVJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755633AbZHKXVJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 19:21:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755562AbZHKXVI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 19:21:08 -0400
Received: from outbound-mail-39.bluehost.com ([69.89.20.193]:34680 "HELO
	outbound-mail-39.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755553AbZHKXVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 19:21:07 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=TOxp36R+XaAKpOP3NLN+wuoLubzV5ivuyFzhVNZjcvVnQjJZ9igcyqw7kCRJy94PQWw42bv6Wad5k5nwiZKvav1wJ9l23S0hvqKS3PgOxsqulaQUri5MgrZ2p5TMlfU8;
Date: Tue, 11 Aug 2009 16:21:03 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Dave Airlie <airlied@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net,
       Tiago Vignatti <tiago.vignatti@nokia.com>
Subject: Re: [PATCH] vga: implements VGA arbitration on Linux
Message-ID: <20090811162103.1b2a65c9@jbarnes-g45>
In-Reply-To: <20090811161746.7b8878aa@jbarnes-g45>
References: <1249969927-884-1-git-send-email-airlied@gmail.com>
	<20090811161746.7b8878aa@jbarnes-g45>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Aug 2009 16:17:46 -0700
Jesse Barnes <jesse.barnes@intel.com> wrote:

> On Tue, 11 Aug 2009 15:52:06 +1000
> Dave Airlie <airlied@gmail.com> wrote:
> 
> > From: Tiago Vignatti <tiago.vignatti@nokia.com>
> > 
> > Background:
> > Graphic devices are accessed through ranges in I/O or memory space.
> > While most modern devices allow relocation of such ranges, some
> > "Legacy" VGA devices implemented on PCI will typically have the same
> > "hard-decoded" addresses as they did on ISA. For more details see
> > "PCI Bus Binding to IEEE Std 1275-1994 Standard for Boot
> > (Initialization Configuration) Firmware Revision 2.1" Section 7,
> > Legacy Devices.
> > 
> > The Resource Access Control (RAC) module inside the X server
> > currently does the task of arbitration when more than one legacy
> > device co-exists on the same machine. But the problem happens when
> > these devices are trying to be accessed by different userspace
> > clients (e.g. two server in parallel). Their address assignments
> > conflict. Therefore an arbitration scheme _outside_ of the X server
> > is needed to control the sharing of these resources. This document
> > introduces the operation of the VGA arbiter implemented for Linux
> > kernel.
> > 
> > Signed-off-by: Tiago Vignatti <tiago.vignatti@nokia.com>
> > Signed-off-by: Dave Airlie <airlied@redhat.com>
> 
> Ok, applied this to my linux-next branch, but I'd like to get Ben's
> s-o-b before pushing it to Linus.

Oh yeah, and we should get the documentation merged too.  I can handle
that or you can send it to Randy.  Tiago?

-- 
Jesse Barnes, Intel Open Source Technology Center
