Return-Path: <linux-kernel-owner+w=401wt.eu-S1756804AbYDIPTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756804AbYDIPTR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 11:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752126AbYDIPTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 11:19:08 -0400
Received: from outbound-mail-109.bluehost.com ([69.89.22.9]:37093 "HELO
	outbound-mail-109.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752735AbYDIPTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 11:19:07 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Jakob Bornecrantz" <wallbraker@gmail.com>
Subject: Re: DRM modesetting & sysfs
Date: Wed, 9 Apr 2008 08:17:02 -0700
User-Agent: KMail/1.9.9
Cc: dri-devel@lists.sourceforge.net,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
References: <200804081317.43712.jbarnes@virtuousgeek.org> <427ca1a20804090157t4fa1bbcei27d3bbea085aa9c3@mail.gmail.com>
In-Reply-To: <427ca1a20804090157t4fa1bbcei27d3bbea085aa9c3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804090817.02836.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, April 09, 2008 1:57 am Jakob Bornecrantz wrote:
> I was going to suggest that you plug it into the hotplug_stage_two
> function but it looks like you have already done that. Things might be
> routed differently now then since the last time I looked at the code,
> are you sure that stage_two is being run?

I'll have to check, I'm not sure I'm even getting interrupts...

> >  Any thoughts on the interface?  Anything in particular people would like
> > to see?
>
> Looks good, can you write to dpms, that is turn a monitor on and of,
> that would be slightly cool but not overly useful. On the whole I
> think exporting properties are fine, but I don't think setting modes
> and crtc's are to be done in sysfs. However it is entirely possible.

Agreed.  I view this more as a way of exporting information about the DRM 
configuration to userspace rather than a way to control the whole thing.  I 
think we should stick with ioctls for the latter...  Anyway thanks for 
checking it out.

Jesse
