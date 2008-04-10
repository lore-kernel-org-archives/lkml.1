Return-Path: <linux-kernel-owner+w=401wt.eu-S1757162AbYDJMtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757162AbYDJMtT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 08:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755499AbYDJMtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 08:49:10 -0400
Received: from relay2.sgi.com ([192.48.171.30]:43688 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755451AbYDJMtJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 08:49:09 -0400
Date: Thu, 10 Apr 2008 07:49:04 -0500
From: Paul Jackson <pj@sgi.com>
To: "Bert Wesarg" <bert.wesarg@googlemail.com>
Cc: travis@sgi.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] cpumask: use new cpus_scnprintf function v3
Message-Id: <20080410074904.2734e52f.pj@sgi.com>
In-Reply-To: <36ca99e90804090853xf62438ayfbfa6010f2d31747@mail.gmail.com>
References: <20080408184301.651388000@polaris-admin.engr.sgi.com>
	<20080408184301.975491000@polaris-admin.engr.sgi.com>
	<36ca99e90804081240q31516fbegadbcc98360813863@mail.gmail.com>
	<47FBD99A.2080007@sgi.com>
	<36ca99e90804090853xf62438ayfbfa6010f2d31747@mail.gmail.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bert, responding to Mike:
> >  It's printing the number of cpus on a node, so the number of nodes is not
> >  important, it's how many cpus can fit on the head of a node... ;-)
> Ahh, the old code was Just Plain Wrong.

Looks like the code originally had NR_CPUS, and that was changed to
MAX_NUMNODES, perhaps as unintended collateral damage from some
x86_64 node SLIT changes done in the patch:

  http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.10-rc3/2.6.10-rc3-mm1/broken-out/x86_64-add-x86_64-support-for-jack-steiners-slit-sysfs.patch

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
