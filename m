Return-Path: <linux-kernel-owner+w=401wt.eu-S933184AbYBONjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933184AbYBONjW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 08:39:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756795AbYBONix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 08:38:53 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:46734 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756235AbYBONiw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 08:38:52 -0500
Date: Fri, 15 Feb 2008 14:37:59 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel@vger.kernel.org, kkeil@suse.de,
       isdn4linux@listserv.isdn4linux.de
Subject: Re: [PATCH 02/14] [ISDN] Hisax: eliminate many unnecessary references to CardType[]
Message-ID: <20080215133759.GI1178@uranus.ravnborg.org>
References: <74fc75b3eadfa82aee70b855e9944b5439a259d5.1203031878.git.jeff@garzik.org> <e6fd205c4444928e0f7176c01e914f4d625a50e9.1203031878.git.jeff@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e6fd205c4444928e0f7176c01e914f4d625a50e9.1203031878.git.jeff@garzik.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2007 at 03:42:07AM -0400, Jeff Garzik wrote:
> For the vast majority of CardType[card->typ] uses (but not all!),
> the string is constant for each driver.  Therefore, we may replace
> CardType[card->typ] with the actual string describing the driver, making
> each printk() a bit more simple.
> 
> This also has the nice, intended side effect of greatly reducing
> external references to hisax global CardType[].  This will be of value
> once the ISDN drivers are converted to the ISA/PCI/PNP hotplug APIs.
> 
> Signed-off-by: Jeff Garzik <jgarzik@redhat.com>

Looks good. No comments.

	Sam
