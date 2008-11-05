Return-Path: <linux-kernel-owner+w=401wt.eu-S1756296AbYKET0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756296AbYKET0g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 14:26:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752687AbYKET01
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 14:26:27 -0500
Received: from yx-out-2324.google.com ([74.125.44.28]:60997 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457AbYKET00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 14:26:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rod6yCm0uzNKtwTm3Dy8gWqSDTGnSaLHdS1e1pWNEp42polDesntve4tbccMYgPsvF
         7gZ5CHZ9IWMzEDzMUDl99NgOZwDyVsfqHXREUeZj3AMbSYL2vnuurS5upj+rMLWRKUsq
         JZUV+9eC+9mPNg4hLOmMK9GXSl992SnfUeotw=
Date: Wed, 5 Nov 2008 22:26:22 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yhlu.kernel@gmail.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v2] x86: Don't allow nr_irqs > NR_IRQS
Message-ID: <20081105192622.GC23548@localhost>
References: <1225819102.3074.15.camel@achroite> <1225886687.3074.59.camel@achroite> <20081105191126.GA23548@localhost> <1225912531.3074.73.camel@achroite>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225912531.3074.73.camel@achroite>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ben Hutchings - Wed, Nov 05, 2008 at 07:15:31PM +0000]
| On Wed, 2008-11-05 at 22:11 +0300, Cyrill Gorcunov wrote:
| [...]
| > Ben I didn't manage to get a look over ACPI related changes
| > (ie to find the reason why the kernel is able to reveal 5 IO-APICs
| >  now
| [...]
| 
| I was mistaken; that *isn't* a recent change.  A default RHEL 5 kernel
| (based on 2.6.18) also finds 5 IOAPICs.
| 
| Ben.
|

So, these io-apics was there for a long time :) and recent dyn-irq
tricks just bared the problem of NR_IRQS for which Yinghai already
sent a patch. Lets wait until they're merged.

		- Cyrill -
