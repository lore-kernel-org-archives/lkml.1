Return-Path: <linux-kernel-owner+w=401wt.eu-S1765511AbYBCLw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765511AbYBCLw3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 06:52:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758675AbYBCLwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 06:52:21 -0500
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:16616 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750968AbYBCLwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 06:52:21 -0500
X-Greylist: delayed 50147 seconds by postgrey-1.27 at vger.kernel.org; Sun, 03 Feb 2008 06:52:20 EST
Message-ID: <47A5AAF0.6090402@ntlworld.com>
Date: Sun, 03 Feb 2008 11:52:16 +0000
From: "A.E.Lawrence" <lawrence_a_e@ntlworld.com>
User-Agent: IceDove 1.5.0.14pre (X11/20071018)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: restore correct module name for apm
References: <47A4E70D.1000607@ntlworld.com> <20080203103213.GC20810@uranus.ravnborg.org>
In-Reply-To: <20080203103213.GC20810@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> The apm module were renamed to apm_32 during the merge of 32 and 64 bit x86 which
> is unfortunate.
> As apm is 32 bit specific we like to keep the _32 in the filename
> but the module should be named apm.
> 
> Fix this in the Makefile.
> Reported by "A.E.Lawrence" <lawrence_a_e@ntlworld.com>

..snip..
> 
> build tested only but obviously correct.
> 
> 	Sam

It is also at
  http://bugzilla.kernel.org/show_bug.cgi?id=9877
which someone (me?) should probably now close.

A E Lawrence
