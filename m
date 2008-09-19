Return-Path: <linux-kernel-owner+w=401wt.eu-S1751694AbYISERr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751694AbYISERr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 00:17:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750737AbYISERj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 00:17:39 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:50913 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbYISERi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 00:17:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=btvMBGfBuNdtAMVcOlK1EBW42yLCceOZmO5NVU1uA/CAwVXac123V2dRUJ3DjAOx9c
         BBS2Kx4KDXRIcnv3FiK/SV8VBT58TibHlZbadPctJU0HW02YxvjW/xtO6cBPi54Ru0qC
         xwpzaKnzgvv9mwyEmbgn2kR6pq7skNnthUHSs=
Date: Fri, 19 Sep 2008 00:17:27 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Arjan Opmeer <arjan@opmeer.net>
Cc: akpm@linux-foundation.org, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: Update Elantech touchpad driver to v5 for
	kernel 2.6.27-rc5-mm1
Message-ID: <20080919041727.GB7594@core.corenet.prv>
References: <20080914032344.GA16228@adopmeer.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080914032344.GA16228@adopmeer.homeip.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arjan,

On Sun, Sep 14, 2008 at 05:23:44AM +0200, Arjan Opmeer wrote:
> 
> From: Arjan Opmeer <arjan@opmeer.net>
> 
> Update the Elantech touchpad driver to v5
> 
> - Put the Elantech entry last in the psmouse_protocols[] list as it is also
>   the last one in the psmouse_type enum.
> - Remove support for relative mode. The driver now always uses the touchpad
>   in absolute mode.
> - Add support for the new Elantech touchpad model as found in the EeePC that
>   uses a new protocol.
> 

Could you tell me if issues with pressure reporting mentioned in
bugzilla #8781 have been resolved? I am about to put the driver in my
tree and need to know if I can enable it unconditionally or need to
mark it experimental.

Thanks!

-- 
Dmitry
