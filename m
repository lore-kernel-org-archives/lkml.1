Return-Path: <linux-kernel-owner+w=401wt.eu-S1754311AbZBUPIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311AbZBUPIv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 10:08:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752183AbZBUPIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 10:08:43 -0500
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:40903 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123AbZBUPIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 10:08:43 -0500
Date: Sat, 21 Feb 2009 15:08:41 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Paolo Ornati <ornati@fastwebnet.it>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Eric Anholt <eric@anholt.net>, Dave Airlie <airlied@linux.ie>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [BISECTED && PACTH AVAILABLE] [drm:i915_initialize] *ERROR* can not ioremap virtual address for ring buffer
Message-ID: <20090221150840.GA28370@silver.sucs.org>
References: <20090221110011.030cb16d@fastwebnet.it> <20090221121944.GA21090@silver.sucs.org> <20090221134933.368c2709@fastwebnet.it> <20090221135233.58fbae0b@fastwebnet.it> <20090221130521.GA13134@silver.sucs.org> <20090221131209.GB13134@silver.sucs.org> <20090221155706.5f6d2184@fastwebnet.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090221155706.5f6d2184@fastwebnet.it>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 21, 2009 at 03:57:06PM +0100, Paolo Ornati wrote:
> 
> Another "problem": every time I switch from X to a text console I get
> this:
> 
> [  156.729311] [drm:i915_get_vblank_counter] *ERROR* trying to get vblank count for disabled pipe 1

Me too. If you are using kernel modesetting then it is probably
http://marc.info/?l=linux-kernel&m=123497969008792&w=2 . There's also a
chance that it is related to
http://bugzilla.kernel.org/show_bug.cgi?id=10628 (which was fixed by
reverting). 

I'm NOT using kernel modesetting but I hadn't reported this issue
because I'm unsure if it's already known (if this really is a regression
from 2.6.28 (which I think it is) then it would be best to file a
separate email/open a kernel bugzilla bug). 

-- 
Sitsofe | http://sucs.org/~sits/
