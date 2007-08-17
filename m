Return-Path: <linux-kernel-owner+w=401wt.eu-S1762392AbXHQRo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762392AbXHQRo3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 13:44:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755901AbXHQRoV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 13:44:21 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:4645 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752926AbXHQRoU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 13:44:20 -0400
Date: Fri, 17 Aug 2007 13:25:22 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       flamingice@sourmilk.net
Subject: Re: rtl8187: Invalid hwaddr! Using randomly generated MAC address
Message-ID: <20070817172522.GD6090@tuxdriver.com>
References: <46C5C5E5.3040503@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46C5C5E5.3040503@tuffmail.co.uk>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Probably want to copy linux-wireless@vger.kernel.org on
wireless-related posts.  Adding Michael Wu to the CC: as well...

John

On Fri, Aug 17, 2007 at 04:59:33PM +0100, Alan Jenkins wrote:
> I've just acquired this buggy piece of hardware otherwise known as a
> NetGear WG111v2.  I googled and eventually found an explanation in the
> form of source code here:
> 
> <http://www.gelato.unsw.edu.au/lxr/source/include/linux/etherdevice.h#L93>.
> 
> 
> It seems linux rejects the hardware MAC address because it is either all
> zero or a multicast address (ie the first byte has 0x01 set.
> 
> On the side of this buggy piece of hardware is written:
> 
> MAC 001B2F7604E6
> 
> which AFAICS is valid; it's definitely not all zeros and the first byte
> has no bits set at all.
> 
> 
> Q.  Udev can't access the invalid mac address.  Does that mean there is
> no persistent identifier for the device?  I know I could identify a
> device as a NetGear WG111v2, but I do have two of them.  It would be
> nice if I could fix them by adding udev rules to identify individual
> devices, and set their MAC address to what it's "supposed" to be.
> 
> /me scrabbles around for a Windows installation to find out whether the
> MAC address is somehow set correctly on the Other OS.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
John W. Linville
linville@tuxdriver.com
