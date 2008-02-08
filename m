Return-Path: <linux-kernel-owner+w=401wt.eu-S932537AbYBHLCQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932537AbYBHLCQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 06:02:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934076AbYBHLBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 06:01:53 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:44703 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934057AbYBHLBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 06:01:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=IUUJ4ZuJF8dy+D3bXTCN2RygRJPi/4FWiJ7Bu/PMBdDjjvEuB3dCOvoBZ7hi9mfaSZCczVD7ykTRLa56w+vdMDKonrYpHMWRSRbcyGEa3LeGRS2LKzt3ISQMAD86TRX6yC8Kq7/8kAmpKlsOhVcyFgheTQ9EIkULZ/gZeGNRrnU=
Message-ID: <47ABD817.2020903@gmail.com>
Date: Fri, 08 Feb 2008 13:18:31 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Jeff Garzik <jeff@garzik.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Mark Lord <liml@rtr.ca>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH #upstream] libata: implement libata.force module parameter
References: <47A3375F.80101@gmail.com> <47A356C3.3010904@garzik.org> <20080201183621.GC14759@uranus.ravnborg.org>
In-Reply-To: <20080201183621.GC14759@uranus.ravnborg.org>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> I have lost the actual patch.
> But what you see is what happens when you mix const and non-const data
> in the same section.
> 
> Look for use of __initdata for const data and replace it with __initconst.
> 
> And modpost cannot warn about it as gcc errors out before we look at the
> .o file with modpost.

OIC, thanks.  Hmmm... in init.h, I see __{dev|cpu|mem}initconst but no
__initconst.  The data structure in question is used from module init
function tagged properly with __init.  What should be done here?


-- 
tejun

