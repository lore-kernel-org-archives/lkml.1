Return-Path: <linux-kernel-owner+w=401wt.eu-S1753925AbXD1TH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925AbXD1TH3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 15:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754052AbXD1TH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 15:07:28 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:53107 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753925AbXD1TH0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 15:07:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=KFD3yh6JEENchnKQA8RRlDEtOscT6CwsVT8vITRQ+mzs95yC7LDgrhAw3N8X4wJTRnyraz4bmOV+3mkrdo3J2UzvnPo6Ls3aNww9CvDc+4kf33AOkuP9J3Tku/F2Ty6cw71ejfPdAmV1NdirEK0Qo7y1XQ5qo2CSZbwJclUi6qU=
Date: Sat, 28 Apr 2007 21:06:49 +0200
From: Diego Calleja <diegocg@gmail.com>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>, stable@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Riccardo Ricci <rricci@nuovanetmore.it>,
       "Udo A. Steinberg" <us15@os.inf.tu-dresden.de>,
       Len Brown <len.brown@intel.com>, David Brownell <david-b@pacbell.net>,
       Jeff Mahoney <jeffm@suse.com>, reiserfs-dev@namesys.com,
       Jeff Chua <jeff.chua.linux@gmail.com>, Francois SIMOND <curio@free.fr>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       netdev@vger.kernel.org,
       =?ISO-8859-1?B?SOVrYW4=?= Lindqvist <lindqvist@netstar.se>,
       Vincent Frentzel <zcecc22@ucl.ac.uk>,
       =?ISO-8859-1?B?RnJhbudvaXM=?= Valenduc 
	<francois.valenduc@skynet.be>,
       Thomas Meyer <thomas.mey@web.de>, Giorgio Lando <patroclo7@gmail.com>,
       Dave Jones <davej@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.21 known regressions (v2) (for -stable team)
Message-Id: <20070428210649.de34a681.diegocg@gmail.com>
In-Reply-To: <46338C5B.4010809@m3y3r.de>
References: <463375E5.5040108@googlemail.com>
	<46338C5B.4010809@m3y3r.de>
X-Mailer: Sylpheed version 2.3.0beta5 (GTK+ 2.10.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

El Sat, 28 Apr 2007 20:03:07 +0200, Thomas Meyer <thomas@m3y3r.de> escribió:

> Please remove this from the regression list. This seems to be an
> userspace only problem and is not related to any kernel driver:
> amarok and/or audacious seems to repeatedly read/write to the X socket:

OK - I added it just to be sure that there wasn't any dynticks regression,
it's gone now.
