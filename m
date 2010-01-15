Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758000Ab0AOSfI (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 13:35:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757741Ab0AOSfH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 13:35:07 -0500
Received: from kroah.org ([198.145.64.141]:38526 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751297Ab0AOSfE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 13:35:04 -0500
Date: Fri, 15 Jan 2010 10:06:37 -0800
From: Greg KH <greg@kroah.com>
To: Eugeni Dodonov <eugeni@mandriva.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: PATCH: asus_oled oops in 2.6.32.2
Message-ID: <20100115180636.GB12146@kroah.com>
References: <4B320CAA.1030708@mandriva.com>
 <20091223174941.GA20331@kroah.com>
 <4B32773F.8030508@mandriva.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B32773F.8030508@mandriva.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 23, 2009 at 06:02:07PM -0200, Eugeni Dodonov wrote:
> On 12/23/2009 03:49 PM, Greg KH wrote:
> > On Wed, Dec 23, 2009 at 10:27:22AM -0200, Eugeni Dodonov wrote:
> >> Hi,
> >>
> >> After updating to 2.6.32 kernel, I started experiencing Oopses caused by
> >> the asus_oled module. After quick investigation, I wrapped this simple
> >> patch which fixes an Oops in by asus_oled module on 2.6.32.2 kernel,
> >> caused by incorrect usage of strict_strtoul function call within
> >> set_enabled and set_disabled functions. This can be triggered by simple
> >> running the userspace client for asus_old (e.g., 'asusoled -e' or
> >> 'asusoled -d').
> > 
> > Looks good, can I get a 'Signed-off-by:' line so that I can apply the
> > patch?
> 
> Sure:
> Signed-off-by: Eugeni Dodonov <eugeni@mandriva.com>

Thanks, I've updated the patch and will send it to Linus later today.

greg k-h
