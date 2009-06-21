Return-Path: <linux-kernel-owner+w=401wt.eu-S1754467AbZFUAFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467AbZFUAFA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 20:05:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752351AbZFUAEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 20:04:53 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:42066 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195AbZFUAEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 20:04:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=WK2EEF517TF9JtCqf73rqpnzH3UHA224eUczAYKMnltPsAfTT/vg0Emz7NUuKju6Pj
         bSSGqVVZp2Vz5wzk13Jr5ps+63ngtoa+JGVlq2xCPo6OuTjvyk3cvn0LZbnwZpsva5dg
         g/ZPtBeM//eMSs49BxYLEK1GDyb/+36e1bMt8=
Subject: Re: [git pull] drm: previous pull req + 1.
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Dave Airlie <airlied@linux.ie>
Cc: torvalds@linux-foundation.org, dri-devel@lists.sf.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.0906200619520.27130@skynet.skynet.ie>
References: <alpine.DEB.2.00.0906200619520.27130@skynet.skynet.ie>
Content-Type: text/plain
Date: Sun, 21 Jun 2009 03:04:50 +0300
Message-Id: <1245542690.6104.6.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-06-20 at 06:23 +0100, Dave Airlie wrote:
> Hi Linus,
> 
> Please pull the 'drm-linus' branch from
> ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-linus
> 
> This is the same tree from the previous pull request + the fix from Pierre 
> that actually makes the PAE/GEM combination on i965 work. \o/

Something from this tree breaks my i965.
Using -git just before this was pulled,

 a552f0af753eb4b5bbbe9eff205fe874b04c4583 works, but using latest git

makes google earth stall, it doesn't update its main window. It appears
that openining and closing its menu, allows it to progress frame after
frame. No crashes hangs however.

Used latest -git of all graphic components (mesa, libdrm, xserver, intel
driver)

KMS is used, as well as UXA and DRI2 (this is enabled by default now)


Compiz used as well, but this happens without it as well.


Best regards,
	Maxim Levitsky

