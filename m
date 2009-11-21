Return-Path: <linux-kernel-owner+w=401wt.eu-S1753787AbZKUAZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787AbZKUAZp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 19:25:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753404AbZKUAZp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 19:25:45 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:40255 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753336AbZKUAZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 19:25:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=GhDktAJM5MrTIXS+fubP+SaOq44wh5Kh3wRnj+OXHO7yS3NHPB8p8cW7AhSNG/FfNj
         5VcsYfCzKJGIvYdzqVoYCCmI6ImQu9HOiXzfoU+aIrJC/6gYEVWUM0dQEvF6hwA3IBsd
         eh4o+icrdRJ0bmapR5Ob9MBoj3tZG/1xKJnHg=
Subject: XD/smartmedia - how to implement it right?
From: Maxim Levitsky <slevmax@t2.technion.ac.il>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Alex Dubov <oakad@yahoo.com>, arnd@arndb.de, joern@logfs.org,
       tglx@linutonix.de
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 21 Nov 2009 02:25:44 +0200
Message-ID: <1258763144.4997.12.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This thread is meant to continue discussion about XD/smartmedia support
in linux.

I CC'd few peoples that participated in original discussion.

Alex Dubov attempted to write a driver for jmicron device (I have it
btw), but this was rejected due to code duplication.

I successfully reverse engineered (in my free time) the XD card reader
found on my laptop (ricoh based one)

I would like to know how you think to implement the subsystem support
right.

I would go with mmc subsystem + FTL, but according to original thread,
there are numerous problems with this approach.

Any advice is appreciated.

Best regards,
Maxim Levitsky

