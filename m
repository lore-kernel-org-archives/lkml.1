Return-Path: <linux-kernel-owner+w=401wt.eu-S1753919AbZLVUAu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919AbZLVUAu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 15:00:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751894AbZLVUAq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 15:00:46 -0500
Received: from kroah.org ([198.145.64.141]:39029 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751641AbZLVUAq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 15:00:46 -0500
Date: Tue, 22 Dec 2009 11:29:37 -0800
From: Greg KH <greg@kroah.com>
To: pancho horrillo <pancho@pancho.name>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Fix a bug on appledisplay.c regarding signedness
Message-ID: <20091222192937.GA13974@kroah.com>
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
> 
> Cheers,
> 
> pancho.
> 
> Signed-off-by: pancho horrillo <pancho@pancho.name>

Care to resend this one with the proper changelog comment so that I can
apply it?

thanks,

greg k-h
