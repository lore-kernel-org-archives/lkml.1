Return-Path: <linux-kernel-owner+w=401wt.eu-S1755980AbYEYRFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755980AbYEYRFs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 13:05:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751452AbYEYRFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 13:05:41 -0400
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:14826 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750855AbYEYRFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 13:05:40 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAKI4OUhQyAc0/2dsb2JhbACBVaoX
Date: Sun, 25 May 2008 19:05:38 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Samuel Tardieu <sam@rfc1149.net>,
       Mike Frysinger <vapier.adi@gmail.com>, Mingarelli@infomag.iguana.be,
       Thomas <Thomas.Mingarelli@hp.com>,
       Jordan Crouse <jordan.crouse@amd.com>, Chen Gong <g.chen@freescale.com>,
       Gabriel C <nix.or.die@googlemail.com>
Subject: Re: [WATCHDOG] v2.6.26-rc3 patches
Message-ID: <20080525170538.GB2646@infomag.infomag.iguana.be>
References: <20080525100944.GA4084@infomag.infomag.iguana.be> <20080525110812.3a05e9fa@core>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080525110812.3a05e9fa@core>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

> There is no locking in geodewdt - so all those routines can end up being
> run together. Not sure it is a problem just noting it while reviewing.

Yep, we need to fix that together with the unlocked_iotcl change also.

Greetings,
Wim.

