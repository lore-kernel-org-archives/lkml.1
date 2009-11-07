Return-Path: <linux-kernel-owner+w=401wt.eu-S1752176AbZKGPXt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176AbZKGPXt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 10:23:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752147AbZKGPXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 10:23:47 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:39139 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123AbZKGPXq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 10:23:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TH1tF8asCcJP7FswVp5uWqgVuwTuPj7KRltQmPL8zb8poDhgtrlNzLvhX5ydIWot3s
         28JHdtwX6Nkh8DkE8Ph0j4Pqr1+XDfiQZKx6in61muD7eDa/X3y6sXQEhI5IJeuEsjF5
         yDNzHLAh07l9xgD+ckuk4lstm56r97HvwaUBk=
MIME-Version: 1.0
In-Reply-To: <20091104154024.0b8f6123.kamezawa.hiroyu@jp.fujitsu.com>
References: <20091104063005.GC3560@balbir.in.ibm.com>
	 <20091104154024.0b8f6123.kamezawa.hiroyu@jp.fujitsu.com>
Date: Sat, 7 Nov 2009 16:23:48 +0100
Message-ID: <63386a3d0911070723m79351432na3d01382df53097b@mail.gmail.com>
Subject: Re: [RFC] Mount point suggestions for cgroup
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: balbir@linux.vnet.ibm.com, libcg-devel <libcg-devel@lists.sourceforge.net>,
       "menage@google.com" <menage@google.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       containers@lists.linux-foundation.org,
       Jan Safranek <jsafrane@redhat.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Bharata B Rao <bharata.rao@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/11/4 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>:

> Then, to say my own not-seriously-considered idea, I vote for
>  - /cgroup/[HierarchyName]/
> rather than /dev/ or /sys or /opt. This sounds straightforward.

I second this. IMHO it is more important to enforce that the mounts
below the topdir are named after the subsystem and only mounted
once for each subsystem, avoiding the multiple-subsystem mounts,
which are a funny way of doing things but in my experience useless.

I have used this hierarchy under /cgroup with libcgroup and
CGFreak in the preliminary Fedora packages and it works like a
charm.

Linus Walleij
