Return-Path: <linux-kernel-owner+w=401wt.eu-S1758273AbYDGNOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758273AbYDGNOw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 09:14:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757395AbYDGNOo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 09:14:44 -0400
Received: from cnc.isely.net ([64.81.146.143]:33965 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757377AbYDGNOn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 09:14:43 -0400
Date: Mon, 7 Apr 2008 08:14:40 -0500 (CDT)
From: Mike Isely <isely@isely.net>
Reply-To: Mike Isely <isely@pobox.com>
To: Meelis Roos <mroos@linux.ee>
cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Michael Krufky <mkrufky@linuxtv.org>,
       Mike Isely at pobox <isely@pobox.com>
Subject: Re: pvrusb2 compile failure
In-Reply-To: <Pine.SOC.4.64.0804070906490.15249@math.ut.ee>
Message-ID: <Pine.LNX.4.64.0804070808120.23745@cnc.isely.net>
References: <Pine.SOC.4.64.0804070906490.15249@math.ut.ee>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Apr 2008, Meelis Roos wrote:

> Got this in todays 2.6.25-rc8+git
> 
>   CC [M]  drivers/media/video/pvrusb2/pvrusb2-devattr.o
> drivers/media/video/pvrusb2/pvrusb2-devattr.c:178: error: unknown field 'flag_has_analogtuner' specified in initializer
> drivers/media/video/pvrusb2/pvrusb2-devattr.c:179: error: unknown field 'flag_has_composite' specified in initializer
> drivers/media/video/pvrusb2/pvrusb2-devattr.c:180: error: unknown field 'flag_has_svideo' specified in initializer
> drivers/media/video/pvrusb2/pvrusb2-devattr.c:182: error: unknown field 'digital_control_scheme' specified in initializer
> drivers/media/video/pvrusb2/pvrusb2-devattr.c:182: error: 'PVR2_DIGITAL_SCHEME_HAUPPAUGE' undeclared here (not in a function)
> drivers/media/video/pvrusb2/pvrusb2-devattr.c:183: error: unknown field 'led_scheme' specified in initializer
> drivers/media/video/pvrusb2/pvrusb2-devattr.c:183: error: 'PVR2_LED_SCHEME_HAUPPAUGE' undeclared here (not in a function)
> make[4]: *** [drivers/media/video/pvrusb2/pvrusb2-devattr.o] Error 1

This was supposed to be a patch that added badly-needed USB IDs to the 
driver (via insert into a devic attribute data table), however it had 
been cherry-picked out of a more recent patch series for the driver 
where those additional fields / identifiers had also been defined.  
Mike Krufky last night fixed his patch and posted it.

  -Mike

-- 

Mike Isely
isely @ pobox (dot) com
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
