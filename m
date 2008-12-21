Return-Path: <linux-kernel-owner+w=401wt.eu-S1753222AbYLUWNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222AbYLUWNT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 17:13:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751511AbYLUWNE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 17:13:04 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:46341 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbYLUWNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 17:13:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:x-x-sender:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type:from;
        b=f4+8nYOScWtx9/lhkQXgr1fQy5zsvx5AKYnO7YBwDyJKf+UJVuPXAf58POyM4qQHCO
         q1O/KAX3J7hduhTZrzYTamqAuuGCgpIXoJs3m0Rm5pdAG9fu69CEHGIF2qZd9TVyTQz1
         APtPZhz7BNbPHxIffgS82j6ck+ZyYaa9cSgB8=
Date: Sun, 21 Dec 2008 17:12:46 -0500 (EST)
X-X-Sender: parag@parag-desktop
To: Jiri Kosina <jkosina@suse.cz>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Parag Warudkar <parag.lkml@gmail.com>,
       Anssi Hannula <anssi.hannula@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: [PATCH] USBHID: Make Boot Protocol drivers depend on EMBEDDED
In-Reply-To: <alpine.LNX.1.10.0812212302400.26265@jikos.suse.cz>
Message-ID: <alpine.DEB.2.00.0812211708450.7101@parag-desktop>
References: <f7848160812201911k7988221asd095ce873fd8105f@mail.gmail.com> <20081220221253.e09b1b1f.akpm@linux-foundation.org> <f7848160812202226w1f930c86vfd17a2b0163bfc56@mail.gmail.com> <494E20F7.7050106@gmail.com> <f7848160812210717w5e5cc7a2uc5571710f755ec99@mail.gmail.com>
 <alpine.LRH.1.10.0812211824350.11630@twin.jikos.cz> <alpine.DEB.2.00.0812211441300.7101@parag-desktop> <alpine.LNX.1.10.0812212247090.26265@jikos.suse.cz> <20081221140200.40c1fec1.akpm@linux-foundation.org>
 <alpine.LNX.1.10.0812212302400.26265@jikos.suse.cz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
From: Parag Warudkar <parag.lkml@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 21 Dec 2008, Jiri Kosina wrote:

> On Sun, 21 Dec 2008, Andrew Morton wrote:
> 
> > > So do I get it right that the only reason of the problem you were 
> > > seeing was that in the 2.6.27 kernel you have compiled usbhid module, 
> > > which was then used for driving your mouse,but in 2.6.28-rcX you 
> > > compiled and used 'usbmouse' instead, and therefore this is not a 
> > > regression?
> > Shouldn't usbmouse support two-dimensional mice as well?
> 
> Yup, but that's a separate issue on my TODO. I first want to know whether 
> this is a regression or not.
> 

I have always compiled usbmouse as a module - the problem or regression 
here was that it was loaded instead of usbhid when both were compiled as 
modules - but I don't think this is a kernel regression, here is why -

The problem happened with Fedora 10 - when I booted into Ubuntu 8.10 with 
the same kernel compiled with same config, usbhid was correctly loaded and 
mouse worked. So I would forget this as a Fedora specific issue.

Thanks for the pointers.

Parag
