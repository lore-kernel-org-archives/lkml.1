Return-Path: <linux-kernel-owner+w=401wt.eu-S1762872AbXGLJVp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762872AbXGLJVp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 05:21:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755776AbXGLJVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 05:21:35 -0400
Received: from wx-out-0506.google.com ([66.249.82.231]:46750 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755348AbXGLJVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 05:21:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=dvvEyDt2cLWwm/TVEL/onob+VPfYlXBFkV7vy3JbO+7CNaYI1btLRx+Lj4xyK3hB8Xsj+nKTVu6xEepByES1SKdMTdLRUpaP0Itw+4gpDqcgYHKYp5MKz/9zUjIksUNKD+fmeNVCM12giKyn5V4yq8FbJWJQV09r8LQlN3JTOzU=
Subject: Re: [2.6 patch] the scheduled ACPI_PROCFS removal
From: Richard Hughes <hughsient@gmail.com>
To: Alexey Starikovskiy <aystarik@gmail.com>
Cc: Bill Davidsen <davidsen@tmr.com>, Jan Engelhardt <jengelh@computergmbh.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Adrian Bunk <bunk@stusta.de>,
       Zhang Rui <rui.zhang@intel.com>, lenb@kernel.org,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <4695BCEA.4060108@gmail.com>
References: <20070709145755.GD3492@stusta.de>
	 <20070709174544.2a6b7067@the-village.bc.nu>
	 <Pine.LNX.4.64.0707092044520.2887@fbirervta.pbzchgretzou.qr>
	 <46951969.4030109@tmr.com>  <4695BCEA.4060108@gmail.com>
Content-Type: text/plain
Date: Thu, 12 Jul 2007 10:18:17 +0100
Message-Id: <1184231897.2380.2.camel@work>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-3.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-07-12 at 09:32 +0400, Alexey Starikovskiy wrote:
> >> [*] Does someone have an alternative for
> >> /proc/acpi/battery/BAT1/{state,info}?
> I'm working on it. Should have proto by the end of week.

If you are using the power_supply class (i hope you are ;-) then a HAL
from freedesktop git should make userspace continue to just work. Please
yell if you notice any differences.

Richard.


