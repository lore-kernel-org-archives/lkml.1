Return-Path: <linux-kernel-owner+w=401wt.eu-S1754334AbYENHAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754334AbYENHAY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 03:00:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752168AbYENHAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 03:00:09 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:57561 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbYENHAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 03:00:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qy6uhOxFMnvrr01sax6c702cSLYJ9bs2rcnhir/nrzUJV+go8eYrkyKVHmQkJAGLfonFS+TpfmpsYkzTtpamWjMv08ie4KKLcYsX+Cn90ilpJ6RMkktbYLKTBUeLNI3SkGHDX0KLs5Wm3PPdR8xS8ExEG6Pphd8ndaGpgTFSnjQ=
Message-ID: <21d7e9970805140000o2191160eida777023909bf033@mail.gmail.com>
Date: Wed, 14 May 2008 17:00:06 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Norbert Preining" <preining@logic.at>
Subject: Re: 2.6.26-rc2 hosed X?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080513103828.GA8288@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080513103828.GA8288@gamma.logic.tuwien.ac.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2008 at 8:38 PM, Norbert Preining <preining@logic.at> wrote:
> Hi all,
>
>  I usually follow the -rc series with skipping the -rc1 (waiting for the
>  worst errors to be fixed).
>
>  Here now a severe regression with respect to 2.6.25: X seems to be hosed
>  in the sense that:
>  - switching to console
>  - suspend 2 ram
>  - suspend 2 disk
>  often leaves the computer completely unusable.
>
>  I am using:
>  - Debian/sid up2date, i.e. xorg server 7.3
>  - intel Chipset 945GM (Acer laptop)
>  - intel xorg video driver 2.2.1 and 2.3.1 (both tested)
>
>  Since not even Sysrq is working I cannot get a log file or whatsoever.
>
>  Is that something known, are is there some patch to revert/test?

You might try pulling in my git tree which Linus ignored last week I
think.. 'drm-patches' branch.

git://git.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-patches

maybe the reverting patch it contains might help..

Dave.
