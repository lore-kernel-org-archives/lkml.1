Return-Path: <linux-kernel-owner+w=401wt.eu-S1760634AbZB0XMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760634AbZB0XMt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 18:12:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754680AbZB0XMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 18:12:41 -0500
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:35177 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660AbZB0XMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 18:12:41 -0500
Date: Fri, 27 Feb 2009 23:12:08 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, airlied@linux.ie,
       eric@anholt.net, keithp@keithp.com, dri-devel@lists.sourceforge.net,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: i915 X lockup
Message-ID: <20090227231207.GA4687@silver.sucs.org>
References: <49A7B253.906@gmail.com> <20090227023231.76e7c65f.akpm@linux-foundation.org> <20090227130440.GA24633@silver.sucs.org> <49A7EF52.8080105@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49A7EF52.8080105@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 27, 2009 at 02:49:06PM +0100, Jiri Slaby wrote:
> On 27.2.2009 14:04, Sitsofe Wheeler wrote:
> >On Fri, Feb 27, 2009 at 02:32:31AM -0800, Andrew Morton wrote:
> >>On Fri, 27 Feb 2009 10:28:51 +0100 Jiri Slaby<jirislaby@gmail.com>  wrote:
> >>
> >>>everytime I run X, it gets stuck. Currently running on mmotm
> >>>2009-02-26-16-58, but I think this is wider problem. I had i915 disabled
> >>>for a long time (until I noticed today).
> >
> >Which version of X are you using? Does it support kernel modesetting? If
> >not, did you disable kernel modesetting in the KConfig file for i915?
> 
> xorg-x11-server-7.4-17.3
> which is
> X.Org X Server 1.5.2
> 
> modesetting enabled:
> CONFIG_DRM_I915_KMS=y
> 
> Which X version is needed for that?

Good question. I can see that 7.4 supports GEM but I see nothing about
kernel modesetting (
http://www.phoronix.com/scan.php?page=article&item=xorg_74_final&num=1).
I know it's enabled in the Fedora (since Fedora 9) xorgs but I have no
idea about openSUSE (which I believe is what you are using based on
package numbers). Apparently kernel modesetting can be turned off on the
kernel command line by using nomodesetting so that might be a quick
thing to try...

-- 
Sitsofe | http://sucs.org/~sits/
