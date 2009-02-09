Return-Path: <linux-kernel-owner+w=401wt.eu-S1754862AbZBIKbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862AbZBIKbm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 05:31:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752635AbZBIKbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 05:31:33 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:43634 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504AbZBIKbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 05:31:32 -0500
Date: Mon, 9 Feb 2009 10:22:04 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
cc: jgarzik@pobox.com, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       alan@lxorguk.ukuu.org.uk, rjw@sisk.pl
Subject: Re: [PATCH] libata-sff: fix 32-bit PIO regression
In-Reply-To: <498F73A5.2070300@ru.mvista.com>
Message-ID: <Pine.LNX.4.64.0902091016520.14410@blonde.anvils>
References: <200902082253.07438.sshtylyov@ru.mvista.com>
 <Pine.LNX.4.64.0902082108290.18661@blonde.anvils> <498F73A5.2070300@ru.mvista.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Feb 2009, Sergei Shtylyov wrote:
> Hugh Dickins wrote:
> 
> > Yes, looks nice, and works for me.  My only criticism would be,
> > minor issue unchanged by your patch, that actually "slop" isn't
> > unlikely enough to deserve an "unlikely" - slop of 1 or 3 is
> > unlikely, but slop of 2 is quite common.
> 
>  Common on what types of ATAPI commands? I can hardly believe that they are
> common on the block I/O...

When I checked (mounting and listing a CD), about 34% of
commands had slop 2.  But you're right, now I try copying
a large file, there's no slop involved in that at all.

Hugh
