Return-Path: <linux-kernel-owner+w=401wt.eu-S1756711AbZHHAe7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711AbZHHAe7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 20:34:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753372AbZHHAe7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 20:34:59 -0400
Received: from mail-yw0-f177.google.com ([209.85.211.177]:57827 "EHLO
	mail-yw0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502AbZHHAe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 20:34:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=PC2d7TIGap/NmoROJn32XclTwXY/c5Xba6WjD17XGyIYM+PqEZ+OMwqbeOgBNe2XbG
         8GuCIqFhyVLN5RJ051VksmtX29Z0CfW9h687YzScwf9Yn7e7+hp0rnTpphYmU2qye3hK
         5Lg2UNtWLtkHwx7PP01Z4/t/d+7hMW/MAm5Po=
Date: Sat, 8 Aug 2009 02:34:53 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
       Andi Kleen <andi@firstfloor.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 3/5] tty: handle VT specific compat ioctls in vt driver
Message-ID: <20090808003451.GK4999@nowhere>
References: <1249564170-18627-1-git-send-email-arnd@arndb.de> <200908070904.11260.arnd@arndb.de> <20090807080428.GB4955@nowhere> <200908071402.11217.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908071402.11217.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 07, 2009 at 02:02:11PM +0200, Arnd Bergmann wrote:
> On Friday 07 August 2009, Frederic Weisbecker wrote:
> > Ok. This looks like a nice series. A bkl pushdown that only goes down
> > in one site among several others enlightens the understanding of what it
> > is protecting (beside the nice fact it also burned three bkl callsites :-)
> 
> Thanks!
> 
> Well, most importantly patch 5/5 fixes a long-standing bug where we held
> the BKL in lots of places that were already proven not to need it, or
> alternatively held it twice (nested) in the ioctls that may still need it.
> 
> I did patch 3/5 this way because I read that you were working on BKL
> removal for TTY and wanted to do my share by removing the dependency
> on the code that I care about (fs/compat_ioctl.h).
> 
> 	Arnd <><

Thanks!

I guess these patches could fit in the tty tree, unless someone has
objections?

