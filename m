Return-Path: <linux-kernel-owner+w=401wt.eu-S933275AbXCYJLv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933275AbXCYJLv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 05:11:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933277AbXCYJLv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 05:11:51 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:53789 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933275AbXCYJLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 05:11:50 -0400
Subject: Re: [v4l-dvb-maintainer] [PATCH] DVB: Delete unused header file
	linux/dvb/version.h.
From: Arjan van de Ven <arjan@infradead.org>
To: Manu Abraham <abraham.manu@gmail.com>
Cc: Marcel Siegert <mws@linuxtv.org>, Andrew Morton <akpm@osdl.org>,
       v4l-dvb-maintainer@linuxtv.org,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <1a297b360703240504u2c9e705m5601d150f15e3c45@mail.gmail.com>
References: <Pine.LNX.4.64.0703231130480.30201@CPE00045a9c397f-CM001225dbafb6>
	 <200703231647.53780.mws@linuxtv.org>
	 <1174665764.1158.241.camel@laptopd505.fenrus.org>
	 <1a297b360703240504u2c9e705m5601d150f15e3c45@mail.gmail.com>
Content-Type: text/plain
Organization: Intel International BV
Date: Sun, 25 Mar 2007 11:11:19 +0200
Message-Id: <1174813880.1158.297.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



> There are cases where we need an API update since newer systems do show up.
> In such a case, the only way is to provide backward compatibility
> while adding in newer stuff.
> 
> Currently we use the version major/minor for the userspace to identify
> the in kernel API, while the userspace apps can remain binary
> compatible

this is the problem exactly! Your userspace binary knows about the
kernel headers it was compiled against, not about the actual running
kernel! They are very likely not the same.

-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

