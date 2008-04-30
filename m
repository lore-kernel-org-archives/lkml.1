Return-Path: <linux-kernel-owner+w=401wt.eu-S1759779AbYD3JkF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759779AbYD3JkF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 05:40:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757141AbYD3Jjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 05:39:43 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:61660 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756368AbYD3Jjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 05:39:42 -0400
X-IronPort-AV: E=Sophos;i="4.25,727,1199682000"; 
   d="scan'208";a="14053522"
Date: Wed, 30 Apr 2008 10:38:32 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: linux-kernel@vger.kernel.org
Cc: cmadams@hiwaay.net, Willy Tarreau <w@1wt.eu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Helge Hafting <helge.hafting@aitel.hist.no>,
       Adrian Bunk <bunk@kernel.org>, "H. Peter Anvin" <hpa@kernel.org>
Subject: Re: [2.6 patch] UTF-8 fixes in comments
Message-ID: <20080430093831.GD4443@implementation.uk.xensource.com>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	linux-kernel@vger.kernel.org, cmadams@hiwaay.net,
	Willy Tarreau <w@1wt.eu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Helge Hafting <helge.hafting@aitel.hist.no>,
	Adrian Bunk <bunk@kernel.org>, "H. Peter Anvin" <hpa@kernel.org>
References: <20080430000851.GH4818@implementation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080430000851.GH4818@implementation>
User-Agent: Mutt/1.5.12-2006-07-14
X-OriginalArrivalTime: 30 Apr 2008 09:38:32.0834 (UTC) FILETIME=[F47EDE20:01C8AAA5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Adams wrote:
> Once upon a time, Samuel Thibault  <samuel.thibault@ens-lyon.org> said:
> >Try init=/bin/sh, from that shell run stty iutf8. Then things will work
> >fine.  The fix is thus just to make the VT's tty initial iutf8 setup
> >follow vt.default_utf8.
> 
> You may also need to select a UTF-8 locale (e.g. LANG="en_US.UTF-8") for
> programs like bash to handle this correctly.

Yes of course, but here the purpose was _not_ programs like bash, but
the canonical mode (i.e. programs like cat etc.), for which the LANG
variable has no effect, only iutf8 has.

Samuel
