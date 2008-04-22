Return-Path: <linux-kernel-owner+w=401wt.eu-S1761557AbYDVJ0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761557AbYDVJ0S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 05:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756430AbYDVJ0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 05:26:09 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:57773 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756681AbYDVJ0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 05:26:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mXRtMSXZeo78Asa4ghPN8tPsqMZ8QrKMbIwtUzPOAEZhivfCEejjaF3eT26+o49irajgMDjPaIjir7y+g5ZHWT2zfIyv/osKbMW5UXd8GvhErAcsc5GRJ06PjjE9iO1kdjLV/AUGa3bceRsOBOvyRm5F4EydHuQtZRctcpgFMQc=
Message-ID: <e85b9d30804220226p142826e7n19f7a0a7b1ef89d0@mail.gmail.com>
Date: Tue, 22 Apr 2008 11:26:05 +0200
From: Matthew <jackdachef@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Fwd: Linux 2.6.25 (coretemp reads high temperatures)
Cc: "Bart Van Assche" <bart.vanassche@gmail.com>,
       torvalds@linux-foundation.org, "Rudolf Marek" <r.marek@assembler.cz>,
       "Gene Heskett" <gene.heskett@gmail.com>, "Len Brown" <lenb@kernel.org>
In-Reply-To: <e85b9d30804211007w9d5a4dds79a98fc9b088caee@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e85b9d30804180837y39c52e26i588e4b67c87a5e9d@mail.gmail.com>
	 <200804182151.49021.lenb@kernel.org> <480CBC92.4070502@archlinux.org>
	 <e85b9d30804210928n6bb08f3bqa4e30741798009fa@mail.gmail.com>
	 <e85b9d30804211007w9d5a4dds79a98fc9b088caee@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---------- Forwarded message ----------
...

(this is the last mail I sent, I apologize if it got there already
 correctly and only my browser displays it corrupted on lkml.org)



 thermal isn't working on this board (if you mean /proc/acpi/thermal_zone ...)

 I also tried a vanilla kernel & it showed the same higher temperature ;(

 here the last mail (on lkml it was corrupted) - I don't know if you
 were able to read it

 >  sure, I'll test-drive the vanilla-kernel, too
 >
 >  thanks

 ok, tested the vanilla-kernel this morning and it shows the exact high
 temperatures (with CONFIG_THERMAL=y)

 I've got a question:

 when trying to disable thermal it just sits there & won't change:
 <*> Hardware Monitoring support  --->
  -*- Generic Thermal sysfs driver  --->

 it seemingly depends on other things:
 Selected by: ACPI_THERMAL && !X86_VOYAGER && ACPI && ACPI_PROCESSOR

 is it safe to disable acpi_processor and acpi or CONFIG_THERMAL in
 general ? or will it burn down my box ? ;)

 I'm asking this because it says/writes:
 CONFIG_ACPI_THERMAL:

 This driver adds support for ACPI thermal zones.  Most mobile and
 some desktop systems support ACPI thermal zones.  It is HIGHLY
 recommended that this option be enabled, as your processor(s)
 may be damaged without it.


 thanks

 Mat
