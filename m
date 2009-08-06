Return-Path: <linux-kernel-owner+w=401wt.eu-S932099AbZHFNx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932099AbZHFNx3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 09:53:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755272AbZHFNx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 09:53:28 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:53294 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754523AbZHFNx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 09:53:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=a/P4gYKxiQeu8aunprFMnrcr+dSEDOYPjDhvB/UC76YPLl7CSx3RANmyRwTjNrpMS3
         f/bsQhB50jISvXIYlsPcPepuOK350s0FXEiebH2b6pwh1IyMSYqDeTBsc7ZhjMWmNd0r
         U6Gr4jzu+iOjQcEAdanV7T9VkNfCZLsUQSgfg=
From: Alberto Gonzalez <alberto6674@gmail.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: Kernel 2.6.30 and udevd problem
Date: Thu, 6 Aug 2009 15:53:23 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.29-ARCH; KDE/4.3.0; x86_64; ; )
Cc: Michal Soltys <soltys@ziu.info>, Dave Airlie <airlied@linux.ie>,
       Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
       linux-hotplug@vger.kernel.org
References: <200906280821.58631.info@gnebu.es> <200907222200.21792.info@gnebu.es> <200907230206.36544.info@gnebu.es>
In-Reply-To: <200907230206.36544.info@gnebu.es>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200908061553.23525.alberto6674@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 23 July 2009 02:06:36 Alberto Gonzalez wrote:
> > On Wednesday 22 July 2009 21:44:36 Jesse Barnes wrote:
> > > Hm, so this type of interrupt problem is *supposed* to be handled by
> > > setting of the PEG_BAND_GAP_DATA reg (low bits set to 0xd).  Do you
> > > have that in your tree?  Does git master have this problem?
>
> I've tested 2.6.31 from git and I can reproduce the problem. Attached is
> the dmesg with the debug patch applied.
>
> > > Maybe we need to add a patch to 2.6.30.x to set PEG_BAND_GAP_DATA as a
> > > workaround (git master already has code to do this properly for HDMI
> > > and DP outputs afaict).

Hi,

No updates here? I was wondering if it would be more useful to open a bug 
report so that it doesn't get lost. It is a rather nasty bug that keeps me 
using .29 kernel, and since it seems to be clear where the problem is it seems 
a pity to let it go...

Regards,
Alberto.
