Return-Path: <linux-kernel-owner+w=401wt.eu-S1754145AbZEYQGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145AbZEYQGZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 12:06:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752588AbZEYQGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 12:06:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57654 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633AbZEYQGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 12:06:18 -0400
Message-ID: <4A1AC1BE.5050500@zytor.com>
Date: Mon, 25 May 2009 09:05:18 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Tomasz Chmielewski <mangoo@wpkg.org>, LKML <linux-kernel@vger.kernel.org>,
       mingo@elte.hu, Alan <alan@lxorguk.ukuu.org.uk>,
       Gerd Hoffmann <kraxel@redhat.com>, jeremy@goop.org, JBeulich@novell.com,
       jbarnes@virtuousgeek.org
Subject: Re: [Xen-devel] Re: [GIT PULL] xen /proc/mtrr implementation
References: <4A1A59DD.7030101@wpkg.org> <20090525091530.GW846@one.firstfloor.org>
In-Reply-To: <20090525091530.GW846@one.firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> 
> To my knowledge the only CPUs with broken PAT are some very old Pentium
> Pros dating from back the time when PAT was new and noone used it.
> On those it should be disabled or the high bits not used.
> 
> The kernel is overall too conservative with its white list.
> 
> Today a lot of other common operating systems use PAT extensively,
> so in general it works on the hardware level.
> 

Well, we don't use the high bits exactly for this reason.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

