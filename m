Return-Path: <linux-kernel-owner+w=401wt.eu-S1753830AbYKYLcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830AbYKYLcV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 06:32:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752257AbYKYLcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 06:32:12 -0500
Received: from mga10.intel.com ([192.55.52.92]:32292 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751304AbYKYLcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 06:32:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,663,1220252400"; 
   d="scan'208";a="407802449"
From: Sheng Yang <sheng@linux.intel.com>
Organization: Intel Opensource Technology Center
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] 8250: Eliminate compile warning of 8250.c
Date: Tue, 25 Nov 2008 19:32:07 +0800
User-Agent: KMail/1.10.3 (Linux/2.6.27-7-generic; KDE/4.1.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
References: <1227585320-3711-1-git-send-email-sheng@linux.intel.com> <200811251851.44768.sheng@linux.intel.com> <20081125111342.5383c957@lxorguk.ukuu.org.uk>
In-Reply-To: <20081125111342.5383c957@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811251932.08050.sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 November 2008 19:13:42 Alan Cox wrote:
> > The logic here is strange...
>
> Why
>
> > If you used old compiler, you would get a warning, and you thought that's
> > ensured we won't delete a intended assignment by mistake.
>
> No.. if you hid the warning by hacking around the compiler mistake with
> extra bogus assignments you would hide a future mistake.

OK, I got it now. 

Comparing the result of deleting a meaningful line, this modification result in 
no more warning.  And you also think one additional BUG_ON just for fixing 
compiler's mistake, so it's unacceptable. 

So leave the patch as it was. Seems many people need to upgrade compiler to 
avoid this thing. :)

-- 
regards
Yang, Sheng

>
> > If you used new compiler, you wouldn't get a warning, and you think this
> > time the compiler get it right.
>
> The compiler does now get it right - I checked.
>
> Alan

