Return-Path: <linux-kernel-owner+w=401wt.eu-S1751445AbYFKN1F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751445AbYFKN1F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 09:27:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750712AbYFKN0y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 09:26:54 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:9778 "EHLO
	SG2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698AbYFKN0x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 09:26:53 -0400
X-BigFish: VPS-54(z6f5iz542N154dM1432R98dR7efV1805Mzzzz1157Pz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0K2AW0C-03-KFH-01
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 3/3] AMD Family10h+ IBS support for oProfile driver: buffer management
Date: Wed, 11 Jun 2008 09:25:45 -0400
Message-ID: <6096959DEF5C9447A6BF80BDC7EB9EDC08650A66@SBOSEXMB1.amd.com>
In-Reply-To: <20080611105345.GF5612@ucw.cz>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 3/3] AMD Family10h+ IBS support for oProfile driver: buffer management
Thread-Index: AcjLsxehj7vl4mueT9CoL1FkFbn8swAE1c4g
References: <20080609175030.2844.77365.sendpatchset@localhost.localdomain> <20080609175052.2844.12167.sendpatchset@localhost.localdomain> <20080611105345.GF5612@ucw.cz>
From: "Kasindorf, Barry" <Barry.Kasindorf@amd.com>
To: "Pavel Machek" <pavel@suse.cz>
CC: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 11 Jun 2008 13:25:46.0730 (UTC) FILETIME=[A847CCA0:01C8CBC6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I can add a changelog, but this is all new and the comments at the head
of the first patch detail the nature of the changes.

I don't know why all those white space changes happened, I did a GIT
diff and it found them. I suspect that there is some trailing whitespace
that got removed, I will check that.
-Barry


-----Original Message-----
From: Pavel Machek [mailto:pavel@suse.cz] 
Sent: Wednesday, June 11, 2008 6:54 AM
To: Kasindorf, Barry
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] AMD Family10h+ IBS support for oProfile driver:
buffer management



On Mon 2008-06-09 13:50:48, Barry Kasindorf wrote:
> Signed-off-by: Barry Kasindorf <barry.kasindorf@amd.com>
> 

missing changelog, lots of strange whitespace changes.

> @@ -33,7 +34,7 @@
>  #include "event_buffer.h"
>  #include "cpu_buffer.h"
>  #include "buffer_sync.h"
> -
> +
>  static LIST_HEAD(dying_tasks);
>  static LIST_HEAD(dead_tasks);
>  static cpumask_t marked_cpus = CPU_MASK_NONE;

I actually do not see the difference here. What is going on?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures)
http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html


