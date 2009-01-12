Return-Path: <linux-kernel-owner+w=401wt.eu-S1756012AbZALR5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012AbZALR5W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 12:57:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753553AbZALR5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 12:57:06 -0500
Received: from outbound-mail-09.bluehost.com ([69.89.17.209]:56225 "HELO
	outbound-mail-09.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751387AbZALR5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 12:57:05 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=oMJBUM855MrG5jWPYHmE2CtCUKfWZphsTaOeJD49GlZSCGNMXB4tNYmyKMORibV5KX7FwF94ao/wi6fZfWRAeuirIMd9uFNptQb8bEM3+KpN7QRMgNpBwstEQ0Crjjm8;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Jan Dittmer" <jdi@l4x.org>
Subject: Re: intel kms "Failed to allocate space for kernel memory manager"
Date: Mon, 12 Jan 2009 09:56:30 -0800
User-Agent: KMail/1.9.10
Cc: "Dave Airlie" <airlied@gmail.com>, "Diego Calleja" <diegocg@gmail.com>,
       linux-kernel@vger.kernel.org, eric.anholt@iintel.com, airlied@linux.ie
References: <621d098f0901110546p2b99a525k5de54e37fa181197@mail.gmail.com> <21d7e9970901120004t2dd68241x6b9533f489601109@mail.gmail.com> <621d098f0901120037y4e17b4bn8d52a8ecdbc3fcff@mail.gmail.com>
In-Reply-To: <621d098f0901120037y4e17b4bn8d52a8ecdbc3fcff@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901120956.31728.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 12, 2009 12:37 am Jan Dittmer wrote:
> On Mon, Jan 12, 2009 at 9:04 AM, Dave Airlie <airlied@gmail.com> wrote:
> > the latest git should work with kms on most chipsets, we are still
> > chasing down some issues on some chipsets,
>
> So is there anything I can test to help you get it going on 'my' chipset
> (GM965, Lenovo X300)?

I do much of my testing on GM965, so you should be able to get it to work with 
the latest bits:
  - libdrm from git master of mesa/drm
  - mesa from git master of mesa/mesa
  - xf86-video-intel from git master
  - drm-intel-next from anholt's kernel tree
    (git://git.kernel.org/pub/scm/linux/kernel/git/anholt/drm-intel)

You'll need to use UXA as your AccelMethod.  If you run into issues with the 
above, please file bugs (if you don't already see your issue filed) at 
bugs.freedesktop.org.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
