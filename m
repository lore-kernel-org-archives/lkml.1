Return-Path: <linux-kernel-owner+w=401wt.eu-S1754552AbXD2EKK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552AbXD2EKK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 00:10:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754561AbXD2EKK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 00:10:10 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:45630 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754552AbXD2EKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 00:10:01 -0400
X-Sasl-enc: xhkXvfrYB1O9NUQVQSRPiqJ2eaKK2fgg1p3rcPkGvrVm 1177819798
Date: Sun, 29 Apr 2007 01:09:53 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Adrian Bunk <bunk@stusta.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, lenb@kernel.org,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [-mm patch] make drivers/misc/thinkpad_acpi:fan_mutex static
Message-ID: <20070429040953.GA29832@khazad-dum.debian.net>
References: <20070425225716.8e9b28ca.akpm@linux-foundation.org> <20070428191938.GO3468@stusta.de> <20070428195821.GC2392@khazad-dum.debian.net> <20070429025008.GK3468@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070429025008.GK3468@stusta.de>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Apr 2007, Adrian Bunk wrote:
> Forward declarations of static functions (if required) and actual 
> variables (like fan_mutex) belong into the C file, not the header.

Very well.  I will fix the mess for 2.6.23, or, time permitting, 2.6.22.

> > Maybe I should just break the driver into multiple files in a subdirectory?
> > That would certainly make it *much* cleaner...
> 
> But even more in this case, you will not want to have actual variables 
> or prototypes of static functions in the header file.

I would not have to, in that case.  The driver would be much easier to
write, and I will need to break it in two for an alsa module anyway, might
as well break it in one subdriver per file.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
