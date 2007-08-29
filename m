Return-Path: <linux-kernel-owner+w=401wt.eu-S1758196AbXH2MqN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758196AbXH2MqN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 08:46:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755259AbXH2Mp6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 08:45:58 -0400
Received: from el-out-1112.google.com ([209.85.162.180]:53946 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755485AbXH2Mp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 08:45:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=TJR86U/vuQQBq2h+/kRZBkzeznyMEGkCIxID2rjf02T+DZBhx+DEVMHw32fRzgWLJSEFL5jt0stmn1HKgs+WZ53cU1w9ATAPKRr5T4YQw1oFHXLgqHb/0WdkrZaI0nkeupE7sjBWuspkdd9NbfK56YXWkK83FGJjD/8zHcmMUy4=
Message-ID: <78171f0a0708290545w7a819177keb959079d0116fb1@mail.gmail.com>
Date: Wed, 29 Aug 2007 07:45:55 -0500
From: "Frank Phillips" <frankalso@gmail.com>
To: "Jean Delvare" <khali@linux-fr.org>
Subject: Re: [lm-sensors] [PATCH] v1 of IBM power meter driver
Cc: "Darrick J. Wong" <djwong@us.ibm.com>,
       "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
       "Yani Ioannou" <yani.ioannou@gmail.com>
In-Reply-To: <20070829114959.5ddb8d79@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070827211446.GG32667@tree.beaverton.ibm.com>
	 <20070828015029.GA10107@khazad-dum.debian.net>
	 <20070828131942.18449886@hyperion.delvare>
	 <20070828162851.GJ32667@tree.beaverton.ibm.com>
	 <20070829114959.5ddb8d79@hyperion.delvare>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> It needs at least review and testing, but maybe there are a few more
> steps before merging can be considered. Adding Yani (the author) to Cc,
> please work with him if you're interested.

As a user, I can tell you that it completely fills my dmesg with this sort

ipmisensors: sensor 50 (type 1) reading 60
ipmisensors: Send 0x2d 0x30 0x0
ipmisensors: received message
ipmisensors: sensor 48 (type 1) reading 28
ipmisensors: Send 0x2d 0x1b 0x0
ipmisensors: received message
ipmisensors: sensor 27 (type 2) reading 34
ipmisensors: Send 0x2d 0x1a 0x0
ipmisensors: received message
ipmisensors: sensor 26 (type 2) reading 187
ipmisensors: Send 0x2d 0x18 0x0

That's the only problem I have. It would be great to see it merged.

Frank
