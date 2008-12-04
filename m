Return-Path: <linux-kernel-owner+w=401wt.eu-S1756316AbYLDTka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756316AbYLDTka (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 14:40:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753761AbYLDTkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 14:40:08 -0500
Received: from main.gmane.org ([80.91.229.2]:41243 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752121AbYLDTkG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 14:40:06 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Jack Tanner <ihok@hotmail.com>
Subject: Re: vanilla kernels hang randomly under Fedora 10 on system with Radeon card
Date: Thu, 4 Dec 2008 19:32:53 +0000 (UTC)
Message-ID: <loom.20081204T192651-568@post.gmane.org>
References: <200812012342.32575.bzolnier@gmail.com> <21d7e9970812012118r7196a507me0a25fe967f60ff4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 204.215.193.100 (Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.0.4) Gecko/2008111217 Fedora/3.0.4-1.fc10 Firefox/3.0.4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Airlie <airlied <at> gmail.com> writes:

> On Tue, Dec 2, 2008 at 8:42 AM, Bartlomiej Zolnierkiewicz
> <bzolnier <at> gmail.com> wrote:
> >
> > Since the following error gets logged by kernel:
> >
> > [drm:drm_buffer_object_validate] *ERROR* Failed moving buffer. cef578c0 1444
4000027 10000a0
> > [drm:drm_buffer_object_validate] *ERROR* Out of aperture space or DRM memory
quota.

Per Bartolomiej's reasoning, I recompiled
xorg-x11-drv-ati-6.9.0-61.fc10.x86_64.rpm without the remove-limit-heuristics
patch. However, I still see errors like the one above. In addition, since
upgrading to F10 I also see visual artifacts on my (composited) desktop. See
Xorg.0.log (generated with the remove-limit-heuristics aptch) as attached to
https://bugzilla.redhat.com/show_bug.cgi?id=469214 .

