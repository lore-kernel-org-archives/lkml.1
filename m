Return-Path: <linux-kernel-owner+w=401wt.eu-S1752974AbZF3Nv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974AbZF3Nv2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 09:51:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751869AbZF3NvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 09:51:19 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:32848 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526AbZF3NvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 09:51:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=iTxjLF/bjH1CwwTWjd0ID6Ysqg9Ai5dcDj8Mh7vyvjvT5cLE7lX+EecMnmVlYpz2Ci
         ibSTy0+xQYGk891Z40r7X5FwdyyQTWI/SnBPswKTKb1ociybgr9vnLZvbsRQVit5owK9
         vxzq5dKPDxf1lJsy6v2C/kucwiSI+a21eFkl0=
Date: Tue, 30 Jun 2009 17:51:18 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] x86: fix arch/x86/lib/clear_page_64.S::clear_page_c
	annotation
Message-ID: <20090630135118.GC5532@lenovo>
References: <1246359240.6103.34.camel@marge.simson.net> <1246362139.20020.1322822615@webmail.messagingengine.com> <1246366820.6538.1.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246366820.6538.1.camel@marge.simson.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Mike Galbraith - Tue, Jun 30, 2009 at 03:00:20PM +0200]
| On Tue, 2009-06-30 at 13:42 +0200, Alexander van Heukelum wrote:
| > Hi Mike,
| > 
| > I agree with the code, but I do have a remark...
| > 
| > The ENTRY() macro already includes the ALIGN, so you could get
| > rid of the preceding ALIGN. But it's just a neatness thing, because
| > two consecutive ALIGNS don't change the resulting binary.
| > 
| > At any rate:
| > 
| > Acked-by: Alexander van Heukelum <heukelum@fastmail.fm>
| > 
| > (maybe the x86-committer feels comfortable enough to remove the ALIGN ;)
| > )
| 
| No doubt, but I can save him the trouble ;-)
| 
| x86: fix incorrect arch/x86/lib/clear_page_64.S::clear_page_c annotation.
| 
| Signed-off-by: Mike Galbraith <efault@gmx.de>
| Acked-by: Alexander van Heukelum <heukelum@fastmail.fm>
| Cc: Ingo Molnar <mingo@elte.hu>
| Cc: Cyrill Gorcunov <gorcunov@gmail.com>
| LKML-Reference: <new-submission>
| 
| ---
|  arch/x86/lib/clear_page_64.S |    5 ++---
|  1 file changed, 2 insertions(+), 3 deletions(-)
|
...

Thanks Mike, here is my Ack (if needed)

Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
 
	-- Cyrill
