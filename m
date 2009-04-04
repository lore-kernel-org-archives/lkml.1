Return-Path: <linux-kernel-owner+w=401wt.eu-S1756740AbZDDS66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756740AbZDDS66 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 14:58:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754273AbZDDS6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 14:58:50 -0400
Received: from goblin.math.gwu.edu ([128.164.244.190]:39697 "EHLO
	goblin.math.gwu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752953AbZDDS6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 14:58:49 -0400
X-Greylist: delayed 2393 seconds by postgrey-1.27 at vger.kernel.org; Sat, 04 Apr 2009 14:58:49 EDT
Date: Sat, 4 Apr 2009 14:14:22 -0400
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: qcserial/gobi firmware loader
Message-ID: <20090404181422.GA27714@gwu.edu>
References: <20090401203726.GA17485@srcf.ucam.org> <20090403025654.GA20146@suse.de> <20090403135719.GD19774@srcf.ucam.org> <20090403150301.GA25846@suse.de> <20090403151237.GA25994@suse.de> <20090403164551.GA23689@srcf.ucam.org> <20090404152731.GA5080@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20090404152731.GA5080@srcf.ucam.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexander Shumakovitch <shurik@gwu.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Messages magic4 magic5 contain the length of the second firmware file that has
to be implanted using the same procedure as in magic2 and magic3 (without
subtracting 8). The CRC checksum has to be updated afterwards.

Thanks,

   --- Alex.

On Sat, Apr 04, 2009 at 04:27:31PM +0100, Matthew Garrett wrote:
> I've reimplemented Alexander's shell scripts for firmware loading in C 
> and added a udev rule to automatically trigger the loading[1]. Thanks to 
> Sergey's hint I've added checksumming support so it should work on other 
> firmwares as well. The firmware needs to be obtained somehow and then 
> put in /lib/firmware/gobi, but should then automatically load when the 
> device is ready.
> 
> You can download this at http://www.codon.org.uk/~mjg59/gobi_loader/
> 
> [1] The firmware to be loaded depends on the user's network, so I can't 
> think of an especially clean way of doing this in kernel.
> -- 
> Matthew Garrett | mjg59@srcf.ucam.org
