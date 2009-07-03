Return-Path: <linux-kernel-owner+w=401wt.eu-S1756093AbZGCDt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093AbZGCDt7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 23:49:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753344AbZGCDtu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 23:49:50 -0400
Received: from smtp-out.google.com ([216.239.45.13]:20446 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049AbZGCDtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 23:49:49 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=hSNg+ORKfrHikMrZOnlpfu279QuC6UyQDnNvPXfcgjPiXEOIKlcvf237INl3TQRLn
	TJqcW/a+8T3Pit9KDqtkg==
MIME-Version: 1.0
In-Reply-To: <20090703022553.GJ19135@count0.beaverton.ibm.com>
References: <20090702231814.3969.44308.stgit@menage.mtv.corp.google.com>
	 <20090702232620.3969.16680.stgit@menage.mtv.corp.google.com>
	 <20090702164649.303c4952.akpm@linux-foundation.org>
	 <2f86c2480907021731h13e0bb95q94f06829eded9aa6@mail.gmail.com>
	 <20090702175341.fd2e26d5.akpm@linux-foundation.org>
	 <6599ad830907021808o6f3bb51eh324e4bf13544d83e@mail.gmail.com>
	 <2f86c2480907021817o79fce75yd9785aab682f7bb4@mail.gmail.com>
	 <20090703022553.GJ19135@count0.beaverton.ibm.com>
Date: Thu, 2 Jul 2009 20:49:48 -0700
Message-ID: <6599ad830907022049k45647d9cp7c53a2b9f13b4625@mail.gmail.com>
Subject: Re: [PATCH 1/2] Adds a read-only "procs" file similar to "tasks" that 
	shows only unique tgids
From: Paul Menage <menage@google.com>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: Benjamin Blum <bblum@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       lizf@cn.fujitzu.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 2, 2009 at 7:25 PM, Matt Helsley<matthltc@us.ibm.com> wrote:
>
> Seriously, I don't think the name "tasks" is ugly. I think "tasks"
> is a nice balance between overly verbose ("cgroup.tasks") and specificity.
> If anything I think the new file should be called "processes", not
> "cgroup.procs". The established convention was "subsys.foo". cgroup is not
> a subsystem of itself hence the names "tasks" and "processes" are just fine.

But that means that every time we add a new cgroup framework control
file, we risk breaking people who happen to already have setups that
use that name. At least if we prefix all new names with "cgroup." it's
easier for people to avoid future clashes. I consider it a mistake on
my part that I didn't give the "tasks" file the "cgroup" prefix when I
originally morphed cpusets into cgroups.

Paul
