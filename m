Return-Path: <linux-kernel-owner+w=401wt.eu-S1753300AbYKYLVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300AbYKYLVS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 06:21:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750878AbYKYLVB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 06:21:01 -0500
Received: from dspnet.fr.eu.org ([213.186.44.138]:2372 "EHLO dspnet.fr.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750812AbYKYLVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 06:21:00 -0500
X-Greylist: delayed 523 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Nov 2008 06:21:00 EST
Date: Tue, 25 Nov 2008 12:12:13 +0100
From: Olivier Galibert <galibert@pobox.com>
To: Sheng Yang <sheng@linux.intel.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       linux-serial@vger.kernel.org
Subject: Re: [PATCH] 8250: Eliminate compile warning of 8250.c
Message-ID: <20081125111213.GA6698@dspnet.fr.eu.org>
Mail-Followup-To: Olivier Galibert <galibert@pobox.com>,
	Sheng Yang <sheng@linux.intel.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
	linux-serial@vger.kernel.org
References: <1227585320-3711-1-git-send-email-sheng@linux.intel.com> <200811251831.34737.sheng@linux.intel.com> <20081125104334.351e94ee@lxorguk.ukuu.org.uk> <200811251851.44768.sheng@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200811251851.44768.sheng@linux.intel.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2008 at 06:51:44PM +0800, Sheng Yang wrote:
> The logic here is strange...
> 
> If you used old compiler, you would get a warning, and you thought that's 
> ensured we won't delete a intended assignment by mistake.
> 
> If you used new compiler, you wouldn't get a warning, and you think this time 
> the compiler get it right.

The new compiler gets it right.  If you delete the assignment with the
new compiler, *then* you get a warning.


> OK. if you worry about "delete a line which does the intended assignment", the 
> updated version with BUG_ON(i == NULL) can help. 

Compile-time error detection is better than runtime.

  OG.
