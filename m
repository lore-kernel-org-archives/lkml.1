Return-Path: <linux-kernel-owner+w=401wt.eu-S1755600AbZBRRyI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600AbZBRRyI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 12:54:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751420AbZBRRxy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 12:53:54 -0500
Received: from outbound-mail-103.bluehost.com ([69.89.22.13]:37781 "HELO
	outbound-mail-103.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751938AbZBRRxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 12:53:53 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=aVdilLPDTrEMjAV1Mj51gfxfleArcA6jXioc70M2zYw4O73r76aP4VmDANNYVXNAKo6gpwwauLHCaujfrWFwLEoeMLjb2NHzLqDRWAliYeWH2+0pxtaqRpgkzmA075Qf;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: ZhangRui <rui.zhang@intel.com>
Subject: Re: i915 regression in 2.6.29-rc5
Date: Wed, 18 Feb 2009 09:53:50 -0800
User-Agent: KMail/1.9.10
Cc: dri_devel@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
References: <1234927467.4707.15.camel@rzhang-desktop>
In-Reply-To: <1234927467.4707.15.camel@rzhang-desktop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902180953.50799.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, February 17, 2009 7:24 pm ZhangRui wrote:
> Hi, all,
>
> I got an i915 failure in 2.6.29-rc5.
>
> problem description: the screen doesn't come back after suspend/resume.
> A workaround is to boot with "nomodesetting".
>
> I got this error message during i915 driver load time,
> [   22.606749] mtrr: type mismatch for e0000000,10000000 old: write-back
> new: write-combining [   22.606752] [drm] MTRR allocation failed
> [   22.606753] .  Graphics performance may suffer.
>
> and this during s3 suspend,
> [ 1093.793257] PM: Syncing filesystems ... done.
> [ 1093.797692] PM: Preparing system for mem sleep
> [ 1094.119502] [drm:i915_get_vblank_counter] *ERROR* trying to get vblank
> count for disabled pipe 1 [ 1094.514290] Freezing user space processes ...
> (elapsed 0.00 seconds) done. [ 1094.514726] Freezing remaining freezable
> tasks ... (elapsed 0.02 seconds) done.
>
> the problem seems to be related with commit
> 9880b7a527ffbb52f65c2de0a8d4eea86e24775e

Note to Rafael: this is not a regression from 2.6.28 since the KMS code is new 
with 2.6.29.

-- 
Jesse Barnes, Intel Open Source Technology Center
