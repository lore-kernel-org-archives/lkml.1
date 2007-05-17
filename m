Return-Path: <linux-kernel-owner+w=401wt.eu-S1760290AbXEQXX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760290AbXEQXX0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 19:23:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755807AbXEQXXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 19:23:19 -0400
Received: from nz-out-0506.google.com ([64.233.162.231]:22406 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755413AbXEQXXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 19:23:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=aWpiC6CyRyZavUfqJpiTI/CqGGdTcM3aKBV0vZ6JwIHjUiYYIDcwbJ/J9D3GwrX70vH6Zloe+W/kx1TpPa3CrY4oyKG8W5LVFBxMgVuBkQSm0gHe5FniM2wbzdMeBtqwckT7TtH9/5Ur6rv45K4NU/fOOZycfcZsswhXUEYCcx8=
Subject: Re: [PATCH 1/3] allow console unregistration
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Jesse Barnes <jesse.barnes@intel.com>
Cc: linux-kernel@vger.kernel.org,
       James Simmons <jsimmons@pentafluge.infradead.org>,
       Dave Airlie <airlied@gmail.com>,
       Jakob Bornecrantz <wallbraker@gmail.com>,
       dri-devel@lists.sourceforge.net
In-Reply-To: <200705171532.28799.jesse.barnes@intel.com>
References: <200705171423.46748.jesse.barnes@intel.com>
	 <200705171532.28799.jesse.barnes@intel.com>
Content-Type: text/plain
Date: Fri, 18 May 2007 07:23:10 +0800
Message-Id: <1179444190.5092.4.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-17 at 15:32 -0700, Jesse Barnes wrote:
> Randy just informed me that the patch limits are bigger now, so here are the
> actual patches.
> 
> This patch allows for proper console unregistration via the VT layer, and
> updates the FB layer to use it.  This makes debugging new console drivers
> much easier, since you can properly clean them up before unloading.
> Antonio already checked it out (and suggested a tweak for the fbcon side)
> so I think it's on its way already via the FB tree.

Sorry, I was busy and got sidetracked so I wasn't able to work on this
for 2 weeks.  Yes, this should work for now, at least for debugging
purposes. I'll work on refining on fbcon side, hopefully for
2.6.22-2.6.23 time frame.

Tony 


