Return-Path: <linux-kernel-owner+w=401wt.eu-S1756393AbZALV7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756393AbZALV7x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 16:59:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752678AbZALV7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 16:59:45 -0500
Received: from outbound-mail-101.bluehost.com ([69.89.22.11]:42068 "HELO
	outbound-mail-101.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752439AbZALV7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 16:59:44 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=gXWxMZB6fpddwHA4IN1hnuP10t5lzszYX+JosQNwPfMd2Bds5jKnHVrzuL7yrM1ziguBaSyty7xR4L/EnbBxZu3pK8JBVfB0MvdDVcp9Iii0r2PHHDoyM/5EbvgwvMwq;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Olivier Galibert <galibert@pobox.com>
Subject: Re: intel kms "Failed to allocate space for kernel memory manager"
Date: Mon, 12 Jan 2009 13:59:39 -0800
User-Agent: KMail/1.9.10
Cc: Dave Airlie <airlied@gmail.com>, Jan Dittmer <jdi@l4x.org>,
       Diego Calleja <diegocg@gmail.com>, linux-kernel@vger.kernel.org,
       eric.anholt@iintel.com, airlied@linux.ie
References: <621d098f0901110546p2b99a525k5de54e37fa181197@mail.gmail.com> <200901120953.50167.jbarnes@virtuousgeek.org> <20090112213235.GA58682@dspnet.fr.eu.org>
In-Reply-To: <20090112213235.GA58682@dspnet.fr.eu.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901121359.40158.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 12, 2009 1:32 pm Olivier Galibert wrote:
> On Mon, Jan 12, 2009 at 09:53:49AM -0800, Jesse Barnes wrote:
> > On the contrary, I think we have way too many options and configuration
> > possibilities.  The more we have, the more likely some combination of
> > them will be broken.
>
> You need to be able to fix wrong data coming from the bios or other roms.
>
> > That said, modes are generally pretty easy to handle, so users can
> > provide them through xrandr and xorg.conf; I don't see that changing.
>
> The intel driver ignores modelines if a bios mode is present, at least
> for lvds.  Check i830_lvds_mode_fixup.

We have an LVDSFixedMode option though; afaik it should allow you to override 
any VBT info.  If not you should file a bug.

-- 
Jesse Barnes, Intel Open Source Technology Center
