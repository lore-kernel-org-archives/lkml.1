Return-Path: <linux-kernel-owner+w=401wt.eu-S1764317AbXGNUcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764317AbXGNUcV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 16:32:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761022AbXGNUcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 16:32:14 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:36888 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760607AbXGNUcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 16:32:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=NqwRAZll3APzvT3QUeeJQsvU/RteL6q8HsF3dcDlZ0pr7v2I+WzKNbBBdnSMLsgQ5cOyFu1WevX6CEkGO+FSZVsjOjePKXL6kpUCQ1q1OCLuyz6nLXJj1iKSP8iPmNCfmSQun8aSZCCbL3pTey8WxqjqYlV1coQhSMyqpQWNiqc=
Subject: Re: Geode GX framebuffer driver: Arcom vs. AMD
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Andrew Paprocki <andrew@ishiboo.com>
Cc: linux-kernel@vger.kernel.org, Jordan Crouse <jordan.crouse@amd.com>
In-Reply-To: <76366b180707141201u14585c2eyeb58f0b7b279ea1b@mail.gmail.com>
References: <76366b180707141201u14585c2eyeb58f0b7b279ea1b@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 15 Jul 2007 04:31:34 +0800
Message-Id: <1184445094.4692.2.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-07-14 at 15:01 -0400, Andrew Paprocki wrote:
> Is there any reason why the GPL framebuffer driver for the GX/GX1/LX
> directly from AMD is not integrated into the kernel and only a custom
> driver for only the GX/GX1 written by Arcom exists?
> (drivers/video/geode/*)
> 
> If you have an LX, the Arcom driver won't work and it is difficult to
> use AMD's patch for 2.6.11 with a more recent kernel because the
> drivers/video/geode directory has filename conflicts with files in the
> patch.
> 
> If there are no issues preventing its inclusion, would updated patches
> be accepted to switch to AMD's framebuffer driver? The AMD patches
> would need to be combined to support all three platforms in the driver
> dir, all sitting on top of the Cimarron HAL installed in lib/cimarron.
> 

There's a patch for the AMD Geode LX which I'm going to send for the -mm
tree soon. Its module name is lxfb.

Tony

