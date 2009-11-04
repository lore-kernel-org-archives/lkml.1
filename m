Return-Path: <linux-kernel-owner+w=401wt.eu-S1752417AbZKDICe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752417AbZKDICe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 03:02:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751165AbZKDICe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 03:02:34 -0500
Received: from ozlabs.org ([203.10.76.45]:52037 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751252AbZKDICd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 03:02:33 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: ego@in.ibm.com
Subject: Re: [PATCH 14/14] cpumask: don't recommend set_cpus_allowed hack in Documentation/cpu-hotplug.txt
Date: Wed, 4 Nov 2009 18:32:31 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Ashok Raj <ashok.raj@intel.com>
References: <200911031459.06857.rusty@rustcorp.com.au> <20091103055723.GA19322@in.ibm.com>
In-Reply-To: <20091103055723.GA19322@in.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911041832.31472.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Nov 2009 04:27:23 pm Gautham R Shenoy wrote:
> Hi Rusty,
> 
> On Tue, Nov 03, 2009 at 02:59:06PM +1030, Rusty Russell wrote:
...
> > +		int err;
> > +		cpu_hotplug_lock();
> 		^^^^^^^^^^^^^^^^^^^
> This needs to be get_online_cpus();

Thanks, both fixed!

Rusty.
