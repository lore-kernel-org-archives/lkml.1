Return-Path: <linux-kernel-owner+w=401wt.eu-S1764882AbXHHMQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764882AbXHHMQW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 08:16:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755191AbXHHMQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 08:16:09 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:33078 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753062AbXHHMQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 08:16:07 -0400
X-Sasl-enc: /5NI0UDuBJKXFQCLBfJB2QjWhpw5g6z+Z/InTbAt2ORo 1186575366
Date: Wed, 8 Aug 2007 09:16:03 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] thinkpad acpi module_exit fix
Message-ID: <20070808121603.GC554@khazad-dum.debian.net>
References: <20070808164334.GA2732@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070808164334.GA2732@darkstar.te-china.tietoenator.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 08 Aug 2007, Dave Young wrote:
> [This fix is not very good for the global variable, any comments are
> welcome.]
> 
> The thinkpad_acpi module_init fail out entrace is not very properly. if
> failing before register driver or before create sysfs file, the
> module_exit will try to remove nonexist sysfs files, the kernel will
> oops.
> 
> Signed-off-by: Dave Young <hidave.darkstar@gmail.com>

NAK, this is already fixed in Len's tree.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
