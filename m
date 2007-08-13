Return-Path: <linux-kernel-owner+w=401wt.eu-S942653AbXHMMpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S942653AbXHMMpq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 08:45:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S940957AbXHMHYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 03:24:30 -0400
Received: from smtp110.sbc.mail.re2.yahoo.com ([68.142.229.95]:29887 "HELO
	smtp110.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S940757AbXHMHY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 03:24:28 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=G4S8DpvWdBUFz42+/CvlNXzzanFolQ/U56KUqmY23ULAO/r7p9HRdY0mMjYCXAl3AAmxHV4acXw30ON8nZLYf5b2oGYMbLGxXJu7Ol38xRPmnx6rdpYO+FTFStFdL/9fjtGN0RMqn8IsQp0SmMASDCEKoHXiC8btPhm37P2VrIo=  ;
X-YMail-OSG: hqzLng8VM1k5abMho0QWPmhduRV7zUp7d8rK6v.i1Mwif2oL.9vPoHAelGZd2k6bEHAQscB1kg--
From: David Brownell <david-b@pacbell.net>
To: joe@perches.com
Subject: Re: [linux-usb-devel] [PATCH] [497/2many] MAINTAINERS - USB HUB DRIVER
Date: Mon, 13 Aug 2007 00:24:23 -0700
User-Agent: KMail/1.9.6
Cc: linux-usb-devel@lists.sourceforge.net, torvalds@linux-foundation.org,
       linux-usb-users@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       johannes@erdfelt.com, akpm@linux-foundation.org
References: <46bffc57.+VLVIUHqG3mGbW2w%joe@perches.com>
In-Reply-To: <46bffc57.+VLVIUHqG3mGbW2w%joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708130024.23968.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 12 August 2007, joe@perches.com wrote:
> Add file pattern to MAINTAINER entry
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 

I seem to be missing some context for these "2many" patches; and
don't really see any in the MARC archives either.  This seems like
about 600 patches out of the blue.  A lot for RC3, even if it is
"just" for the MAINTAINERS file.

Is the motivation here purely to make it easier to find out how to
report bugs and suggest improvements?  If so, that seems like only
one of many related issues ...

Is there general agreement that these "F:" entries should be used?
Rather than, say, embedding references in the relevant parts of
the source tree, adjacent to those files, where they would be more
visible to people making relevant changes.

I'm also concerned with the reality that the MAINTAINERS file is
not accurate.  The $SUBJECT patch is one example; the named maintainer
is no longer active (in that area, at least) and the named driver is
not actually separable from the rest of usbcore.  Better IMO to just
remove the "hub driver" entry.


