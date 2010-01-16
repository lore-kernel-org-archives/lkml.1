Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752288Ab0APMpg (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 07:45:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751251Ab0APMpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 07:45:35 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:37177 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049Ab0APMpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 07:45:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=wV92oOzMTX0Vyu1tpMXp1GnaGayqh5OIXF5/PggBUY+CjqDSA2v94yQVidQFIHq1nV
         BqxPqqW2BREsO3LgnMix3DgLr8l6GHOez7JadPjUAkx/Pnw1gttQf3itW2IEuOvsKs6l
         lNS6uC83yAQnq4qKFkSuyaz+OjJdsh8OfrGuI=
Date: Sat, 16 Jan 2010 13:45:31 +0100
From: Johan Hovold <jhovold@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Johan Hovold <jhovold@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/13][v2] USB: serial: fix DMA buffers on stack and
 endianess bugs
Message-ID: <20100116124531.GA17276@localhost>
References: <1262037718-31424-1-git-send-email-jhovold@gmail.com>
 <1262274489-12447-1-git-send-email-jhovold@gmail.com>
 <20100115185034.GF12146@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100115185034.GF12146@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 15, 2010 at 10:50:34AM -0800, Greg KH wrote:
> On Thu, Dec 31, 2009 at 04:47:56PM +0100, Johan Hovold wrote:
> > Hi, 
> > 
> > Here's an updated series rebased against rc2 with all patches from Greg's tree
> > applied. The mct_u232 patch has been dropped as it had already been fixed. I
> > also updated the ch341 and cypress_m8 patches to use the unaligned macros. 
> 
> Ok, I took your original series (sorry, didn't read ahead) and then
> added 2 new ones for the ch341 and cypress_m8 unaligned stuff.  Please
> verify that I got all of this correct.

Looks good.

/Johan

