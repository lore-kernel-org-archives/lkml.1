Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933775Ab0CLRdr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 12:33:47 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:37822 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933630Ab0CLRdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 12:33:46 -0500
X-Sasl-enc: 43VQit38q+U07EcC/sIdoRbZ19CKr9CoJT/VTh5FGKTH 1268415225
Date: Fri, 12 Mar 2010 14:33:42 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       "rpurdie@rpsys.net" <rpurdie@rpsys.net>
Subject: Re: [PATCH] backlight: provide sysfs percent brightness attribute
Message-ID: <20100312173341.GA4931@khazad-dum.debian.net>
References: <0D753D10438DA54287A00B02708426976368437C8D@AUSP01VMBX24.collaborationhost.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0D753D10438DA54287A00B02708426976368437C8D@AUSP01VMBX24.collaborationhost.net>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Mar 2010, H Hartley Sweeten wrote:
> It's usually more convenient to set the backlight brightness
> as a 'percent' of total brightness rather than using the raw
> 'brightness' value.

Well, that scale is often not linear, so you are not dealing with fractions
of the effective brightness, just with fractions of an arbritary scale
exported by the backend driver.  Much of the "usefulness" of a "percent"
scale dies right there.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
