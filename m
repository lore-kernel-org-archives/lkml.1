Return-Path: <linux-kernel-owner+w=401wt.eu-S1752694AbXBEEVI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694AbXBEEVI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 23:21:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752693AbXBEEVI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 23:21:08 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:32177 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694AbXBEEVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 23:21:07 -0500
Subject: clocksource v13
From: Daniel Walker <dwalker@mvista.com>
To: akpm@osdl.org
Cc: johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.com,
       linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Sun, 04 Feb 2007 20:19:26 -0800
Message-Id: <1170649167.9781.309.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I released another version of my clocksource update. I incorporated some
of Ingo's suggestions. I also tested my changes on an older Sony Vaio
where the TSC stops in C2/C3. I noticed that generic time already marks
the TSC unstable if the system enters C2/C3 . So the verify code doesn't
need to run. If I disable that the TSC is detect the same with both sets
of changes. I haven't found a VAIO that has random frequency changes. If
it's a rare condition we can use the DMI black list to avoid using it on
those system.

Download from,

ftp://source.mvista.com/pub/dwalker/clocksource/clocksource-v13/


Daniel

