Return-Path: <linux-kernel-owner+w=401wt.eu-S2992474AbXCGWJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992474AbXCGWJW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 17:09:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992473AbXCGWJW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 17:09:22 -0500
Received: from pne-smtpout1-sn1.fre.skanova.net ([81.228.11.98]:46386 "EHLO
	pne-smtpout1-sn1.fre.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2992474AbXCGWJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 17:09:20 -0500
X-Greylist: delayed 4201 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Mar 2007 17:09:20 EST
Message-ID: <45EF275E.4060300@gmail.com>
Date: Wed, 07 Mar 2007 21:58:06 +0100
From: johan henriksson <jhn98032@gmail.com>
User-Agent: Mozilla Thunderbird 1.0 (Windows/20041206)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Chuck Ebbert <cebbert@redhat.com>
CC: linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: Radeon xpress 200m and radeonfb kinda work
References: <45ECB2D0.3080205@telia.com> <45EEEBC9.1010002@redhat.com>
In-Reply-To: <45EEEBC9.1010002@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck Ebbert wrote:
>  Johan Henriksson wrote:
>
> > Hi!
> >
> > I have gotten the radeon xpress 200m (the version without dedicated
> > vmem) to work with radeonfb. The attached patch (against
> > linux-2.6.20.1) works for me. Since I don't have any docs for the
> > card I am unsure if the patch is 100% correct. Can someone else
> > with a 200m try it out? (I have tested it by enabling fbcon and
> > radeonfb in the kernel and added "video=radeonfb" to lilo. This
> > gave me a nice 1280x800 console :) )
> >
>
>  Works for me as a module on Compaq V2000 notebook. 160x48 is a bit
>  small, but looks very clear and crisp.
>
>  Is there anything else needed to get this merged?
>

As you can see in the patch I have disabled "Dynamic Clock PM"
since it makes my card freak out (Don't know why :(  ).
Is there a reason why the "default_dynclk" parameter only is available
when radeonfb is built as a module or should it be added to radeonfb_setup?

/Johan Henriksson


