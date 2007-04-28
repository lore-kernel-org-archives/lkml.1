Return-Path: <linux-kernel-owner+w=401wt.eu-S1030938AbXD1CZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030938AbXD1CZj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 22:25:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030954AbXD1CZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 22:25:39 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:48321 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030938AbXD1CZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 22:25:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=AA//wiQb4Qd1SRC3rKRjtn0p+oo+AIoDMYsFP3PQ31s/1nxtAgJpkrguYErU8XbWoVaEBKpdkjtYKsiZmJ2IB72lEfnvShWcJbkrb1CMLnfciS4Le12cGDh9fL+3ljGK1ap6H5uMRkOfkULSC3n/stg0IbNW0za/ToEViVs1PDs=
Subject: Re: X display shift with disabled console blanking
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: James Pearson <james-p@moving-picture.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <46322E08.3040303@moving-picture.com>
References: <46322E08.3040303@moving-picture.com>
Content-Type: text/plain
Date: Sat, 28 Apr 2007 10:24:57 +0800
Message-Id: <1177727097.7568.6.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-04-27 at 18:08 +0100, James Pearson wrote:
> I have a problem whereby the X display 'shifts' to left when anything 
> writes to /dev/console - where console screen blanking has been disabled 
> i.e. doing something like:
> 
> boot to run level 3
> 
> If not root, then make sure /dev/console is writeable
> 
> login and type:
> 
> setterm -blank 0
> 
> start X
> 
> type into an xterm:
> 
> echo "some random text" > /dev/console
> (may have to repeat the echo above a few times)
> 
> ... and the whole X display jumps (and wraps) to the left
> 
> I'm using a RHEL4 based distro with a vanilla 2.6.21 x86_64 kernel 
> (although I've seen the problem with various x86_64 and i686 2.6.X kernels).
> 
> I've seen this problem on a number of different nVidia cards - using 
> the vesa driver (same problem occurs with nVidia's binary driver). I 
> haven't tried using other makes of graphics cards.
> 
> 
> OK, this may be a strange combination of disabling the text console 
> blanking and running X, but something isn't right somewhere ...

Yep, it's strange because I can't reproduce this. And the console write
should not succeed if the current console is in KD_GRAPHICS mode, which
is done by X (unless your version is different).

> 
> Any ideas?

I don't.  But, what is your current console?  Is it VGA, or framebuffer?
Can you try doing this again in both VGA and vesafb?

And this does not happen if there is no previous setterm -blank 0
command?

Tony


