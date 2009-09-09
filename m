Return-Path: <linux-kernel-owner+w=401wt.eu-S1753286AbZIIO2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286AbZIIO2c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 10:28:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752697AbZIIO2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 10:28:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54892 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752524AbZIIO2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 10:28:31 -0400
Date: Wed, 9 Sep 2009 07:28:28 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Knut Petersen <Knut_Petersen@t-online.de>
cc: airlied@linux.ie, linux-kernel@vger.kernel.org,
       ykzhao <yakui.zhao@intel.com>, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: Regression DRM/i915/KMS: VGA connector unusable after 2.6.31-rc8-git1,
 DVI connector ok
In-Reply-To: <4AA7549B.5040905@t-online.de>
Message-ID: <alpine.LFD.2.01.0909090719070.7458@localhost.localdomain>
References: <4AA6D858.6040505@t-online.de> <alpine.LFD.2.01.0909081607400.7458@localhost.localdomain> <4AA7549B.5040905@t-online.de>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 9 Sep 2009, Knut Petersen wrote:
> 
> As the old X does not work with the new kernel, I cannot decide if the 
> kernel or X is to blame.

Hmm. Doesn't old X work if you disable KMS? Either with "i915.modeset=0" 
or by just compiling it out?

Also, glxgears is usually not a good way to verify anything. At least some 
versions used to run the gears at the painting frame rate rather than some 
fixed rate, and so "jerky" or not depended not on how fast it was 
painting, but on whether the painting speed was some multiple of the 
screen refresh.

The FPS output from glxgears should mean something, although quite 
frankly, considering the simplicity of the thing, not a whole lot. I'd 
suggest using some somewhat more real test (I admit to having used 
"Extreme Tux Racer", which while not wonderful either is certainly better 
than glxgears ;^)

		Linus
