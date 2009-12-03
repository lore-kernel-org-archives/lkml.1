Return-Path: <linux-kernel-owner+w=401wt.eu-S1754805AbZLCDZP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805AbZLCDZP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 22:25:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753421AbZLCDZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 22:25:14 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39559 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753089AbZLCDZN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 22:25:13 -0500
Date: Wed, 2 Dec 2009 19:20:48 -0800
From: Greg KH <gregkh@suse.de>
To: pancho horrillo <pancho@pancho.name>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Fix a bug on appledisplay.c regarding signedness
Message-ID: <20091203032048.GA29127@suse.de>
References: <20091202191942.GA7362@pancho.name>
 <20091202193104.GB7362@pancho.name>
 <4B16C233.6020808@ru.mvista.com>
 <20091202204421.GA1786@pancho.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091202204421.GA1786@pancho.name>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 02, 2009 at 09:44:21PM +0100, pancho horrillo wrote:
> On Wed, Dec 02, 2009 at 10:38:27PM +0300, Sergei Shtylyov wrote:
> > Hello.
> > 
> > pancho horrillo wrote:
> > 
> > >Please, review and push the patch, if you deem it adequate.
> > 
> > >Thanks a bunch!
> > 
> >    That 'uint8_t' is for userspace, use 'u8' instead.
> > 
> > WBR, Sergei
> 
> Thanks for the coaching, Sergei!
> 
> BTW, there are about 4863 of uint8_t in the kernel sources :-)

And please don't try to add any new ones :)

thanks,

greg k-h
