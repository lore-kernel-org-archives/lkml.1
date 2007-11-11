Return-Path: <linux-kernel-owner+w=401wt.eu-S1757194AbXKKXmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757194AbXKKXmg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 18:42:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755126AbXKKXm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 18:42:29 -0500
Received: from hpsmtp-eml19.kpnxchange.com ([213.75.38.84]:28130 "EHLO
	hpsmtp-eml19.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755032AbXKKXm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 18:42:28 -0500
From: Frans Pop <elendil@planet.nl>
To: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: Bind mount bug?
Date: Mon, 12 Nov 2007 00:42:26 +0100
User-Agent: KMail/1.9.7
Cc: Roland Kuhn <rkuhn@e18.physik.tu-muenchen.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200711111106.53494.elendil@planet.nl> <Pine.LNX.4.64.0711112326030.25431@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0711112326030.25431@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711120042.26861.elendil@planet.nl>
X-OriginalArrivalTime: 11 Nov 2007 23:42:27.0418 (UTC) FILETIME=[846BFBA0:01C824BC]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 11 November 2007, Jan Engelhardt wrote:
> >This mounts the bindtest/ tree on test/ _without_ copying the mount
> >points which are found on subtrees. This is necessary to avoid loops
> >in the filesystem (bind mounts are somewhat like hardlinks on
> >directories, just without the headaches).
>
> What you seek is mount --rbind.

Thanks! That works fine with mount from util-linux-ng.

Busybox' mount (at least Debian's admittedly old 1.1.3 version) seems to 
fail to do the recursing. I'll file a BR against busybox in Debian and 
check that again when we have a more current version.
