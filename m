Return-Path: <linux-kernel-owner+w=401wt.eu-S1762235AbXEUROZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762235AbXEUROZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 13:14:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756598AbXEUROR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 13:14:17 -0400
Received: from smtp23.orange.fr ([193.252.23.111]:8850 "EHLO smtp23.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755902AbXEUROQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 13:14:16 -0400
X-Greylist: delayed 1391 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 May 2007 13:14:15 EDT
X-ME-UUID: 20070521165103328.503CC700009D@mwinf2313.orange.fr
Subject: Re: [RFC] enhancing the kernel's graphics subsystem
From: Xavier Bestel <xavier.bestel@free.fr>
To: Dave Airlie <airlied@gmail.com>
Cc: Jon Smirl <jonsmirl@gmail.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Helge Hafting <helge.hafting@aitel.hist.no>,
       Jesse Barnes <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org
In-Reply-To: <21d7e9970705210927s1454dc5ete89005715253f4b7@mail.gmail.com>
References: <200705171423.46748.jesse.barnes@intel.com>
	 <21d7e9970705210227x27234e2dme4e731a53f977082@mail.gmail.com>
	 <46516A14.2000102@aitel.hist.no>
	 <200705210857.44911.jbarnes@virtuousgeek.org>
	 <9e4733910705210907g70142adfhcaf01bd6791f113d@mail.gmail.com>
	 <21d7e9970705210927s1454dc5ete89005715253f4b7@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 21 May 2007 18:50:55 +0200
Message-Id: <1179766255.7699.216.camel@frg-rhel40-em64t-04>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-05-21 at 17:27 +0100, Dave Airlie wrote:
> > What about modifying the existing fbdev API? You could start with
> one
> > fbdev device per CRTC and then add a new IOCTL to control the output
> > device. I haven't seen anything yet that justifies abandoning the
> > existing fbdev API.
> 
> Then you can't aribtrate properly output hooking is a root level
> thing, you cannot allow the user in multiseat to just pick his own
> outputs, if you claim to want a truly flexible interfaces, also the
> crtc->output mappings aren't always simple, there are limitations on
> most hw about which crtc can map to which output and when you can
> clone etc.. putting policy for this stuff in-kernel would heavily
> restrict what the user can do...

Policy for this kind of thing should just go in HAL's ConsoleKit:
http://lists.freedesktop.org/archives/hal/2007-January/007111.html

	Xav


