Return-Path: <linux-kernel-owner+w=401wt.eu-S1754950AbZD0DjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950AbZD0DjS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 23:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752904AbZD0DjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 23:39:00 -0400
Received: from kroah.org ([198.145.64.141]:58867 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752757AbZD0Di7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 23:38:59 -0400
Date: Sun, 26 Apr 2009 20:31:43 -0700
From: Greg KH <greg@kroah.com>
To: Ozan =?utf-8?B?w4dhxJ9sYXlhbg==?= <ozan@pardus.org.tr>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: The current status of info, err and warn macros in kernel
Message-ID: <20090427033143.GA23388@kroah.com>
References: <49F39786.6020303@pardus.org.tr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49F39786.6020303@pardus.org.tr>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 26, 2009 at 02:06:46AM +0300, Ozan Çağlayan wrote:
> Hi,
> 
> I noticed that I can't compile some out-of-tree modules like lirc,
> lmpcm_usb on my 2.6.30_rc* source tree.
> The compiler aborts saying "implicit declaration of function 'info'". I
> googled and found the following thread
> in linux-next mailing list:

Like was pointed out, they are really gone now.  They were usb-only
functions, that didn't make sense anymore, and lots of other drivers
were using them instead.

Convert to use the dev_* functions instead, those are also backwards
compatible, which should make your life a bit easier.

good luck,

greg k-h
