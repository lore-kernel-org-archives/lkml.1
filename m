Return-Path: <linux-kernel-owner+w=401wt.eu-S1753068AbZG2Skk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753068AbZG2Skk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 14:40:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751740AbZG2Skk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 14:40:40 -0400
Received: from fmmailgate04.web.de ([217.72.192.242]:48329 "EHLO
	fmmailgate04.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559AbZG2Skj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 14:40:39 -0400
Date: Wed, 29 Jul 2009 20:40:39 +0200
Message-Id: <844950876@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: Tomas Carnecky <tom@dbservice.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Show module version sysfs file for built-in modules?
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX1/sRGD3zdLmwe8JM9KqYjLeVxndYE3il05Y9Z7RqMuyZDLrQ
 94Pjdq02cZ4DiwzTrhu4vinMy5dSfCr2XBRIaVucYmCjDNSOcg=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

what about this ?

neoware:/sys/module/8139too # cat /sys/module/8139too/version
0.9.28

neoware:/sys/module/8139too # modinfo 8139too |grep "^version:"
version:        0.9.28

the latter should work completely without consulting the kernel for that information. 

regards
roland

>List:       linux-kernel
>Subject:    Show module version sysfs file for built-in modules?
>From:       Tomas Carnecky <tom () dbservice ! com>
>Date:       2009-07-24 19:08:51
>Message-ID: 5A77D882-B628-4105-85A3-ADE423BBD9F8 () dbservice ! com
>[Download message RAW]
>
>Some userspace tools check /sys/modules/XYZ/version to determine  
>whether the required module is available and the version compatible  
>with the userspace tool. But that sysfs file is not shown when the  
>module is built into the kernel (as opposed being a loadable module).  
>Is there a reason for that behavior? Or is there another way for  
>userspace to check the presence and version of a module?
>The userspace tool in question here is the open-iscsi daemon (iscsid)  
vwhich checks /sys/modules/scsi_transport_iscsi/version and refuses to  
>start if that file doesn't exist.
>
>thanks
>tom

________________________________________________________________
Neu: WEB.DE Doppel-FLAT mit Internet-Flatrate + Telefon-Flatrate
für nur 19,99 Euro/mtl.!* http://produkte.web.de/go/02/

