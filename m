Return-Path: <linux-kernel-owner+w=401wt.eu-S935452AbYBCOEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935452AbYBCOEy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 09:04:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758965AbYBCOEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 09:04:46 -0500
Received: from hu-out-0506.google.com ([72.14.214.239]:23802 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758685AbYBCOEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 09:04:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=ZlX85i+K9X4FivcBnT9v3zry1rbMoTRxLZ/5Ibt8FjJ2gV8Vpa8UiOvDT+9EU4+/IvvHU4drJWFECFJFGL8ZMNA7v97C6WQio+SzZ9rzYL4NIcMo1NzWzdWG2N0OtceEaPUHizSXxW83X3iWyDn0UFHEktCGGHppS7OL2CSs1Xc=
Date: Sun, 3 Feb 2008 17:04:19 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net, bryan.wu@analog.com,
       dhowells@redhat.com
Subject: Re: [patch 1/4] AVR32: cleanup - use _AC macro to define PAGE_SIZE
Message-ID: <20080203140419.GB11983@cvg>
References: <20080203112217.126814108@gmail.com> <47a5a660.19e7300a.0584.329a@mx.google.com> <20080203142506.2003e5cf@siona>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080203142506.2003e5cf@siona>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Haavard Skinnemoen - Sun, Feb 03, 2008 at 02:25:06PM +0100]
| [removed bogus @atmel.co address from Cc]
| 
| On Sun, 03 Feb 2008 14:22:18 +0300
| Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| 
| > Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
| 
| Applied, thanks.
| 
| I found myself having to grep through include/linux to figure out what
| this _AC macro was really all about, so I added this to the description:
| 
|     PAGE_SIZE is used both from assembly and C code. We want to have type
|     specifiers when using it from C, but this will make the assembler
|     confused, so we need to make it conditional.
|     
|     This is exactly what the _AC macro is for, so using it allows us to
|     get rid of a few lines of cpp noise.
| 
| My first thought was "Autoconf", and it sent shivers down my spine ;-)
| 
| Haavard
| 

Thanks, Haavard. (btw, really good joke about Autoconf ;-)

		- Cyrill -
