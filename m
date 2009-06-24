Return-Path: <linux-kernel-owner+w=401wt.eu-S1752263AbZFXF5p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263AbZFXF5p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 01:57:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751240AbZFXF5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 01:57:35 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:48635 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751234AbZFXF5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 01:57:34 -0400
Message-ID: <4A41C04F.6050909@snapgear.com>
Date: Wed, 24 Jun 2009 15:57:35 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: sfking@fdwdc.com
CC: linux-kernel@vger.kernel.org, uclinux-dev@uclinux.org,
       linux-m68k@vger.kernel.org
Subject: Re: [PATCH 00/13] revised Coldfire generic GPIO (mk68nommu)
References: <1245460272-4329-1-git-send-email-sfking@fdwdc.com>
In-Reply-To: <1245460272-4329-1-git-send-email-sfking@fdwdc.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

sfking@fdwdc.com wrote:
> Revised implementation of generic gpio for the Freescale Coldfire family of
> processors (m68knommu).   It uses gpiolib and provides both fast inline
> operations when the gpio is a compile time constant and slower outline
> operations dispatched via gpiolib when the gpio is a variable. 
> 
> There are also hooks for implementing pin multiplexing but that part isn't
> finished yet.
> 
> 
> The major difference with the previous version is the move to a per-platform
> setup code as suggested by Greg Ungerer <gerg@snapgear.com>.
> 
> Additionally, it fixes the definition of the TIMER gpio pins in the 5271
> (thanks to Richard Retanubun <RichardRetanubun@ruggedcom.com>).

This looks pretty good to me.
Do you want me to apply the the m68knommu git tree?
(Ideally I'll push it to Linus in the 2.6.32 merge window).

Regards
Greg



------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
