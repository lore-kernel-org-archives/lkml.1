Return-Path: <linux-kernel-owner+w=401wt.eu-S1758148AbXJDRbg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758148AbXJDRbg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 13:31:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752018AbXJDRb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 13:31:29 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:40681 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754697AbXJDRb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 13:31:28 -0400
Date: Thu, 4 Oct 2007 10:31:19 -0700
From: Paul Jackson <pj@sgi.com>
To: "Paul Menage" <menage@google.com>
Cc: akpm@linuxfoundation.org, balbir@linux.vnet.ibm.com, serue@us.ibm.com,
       clg@fr.ibm.com, ebiederm@xmission.com, xemul@openvz.org,
       rientjes@google.com, svaidy@linux.vnet.ibm.com, nickpiggin@yahoo.com.au,
       a.p.zijlstra@chello.nl, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/33] task containersv11 make cpusets a client of
 containers
Message-Id: <20071004103119.ac841fb0.pj@sgi.com>
In-Reply-To: <6599ad830710040816p63108ab1vb8547b9600b9e659@mail.gmail.com>
References: <20070917210307.116234000@menage.corp.google.com>
	<20070917210427.888917000@menage.corp.google.com>
	<20071004025355.4a096316.pj@sgi.com>
	<6599ad830710040816p63108ab1vb8547b9600b9e659@mail.gmail.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul M wrote:
> It's two constant-indexed dereferences *in total*, compared to a
> single constant-indexed dereference in the pre-cgroup case.

Ok - the C expression is longer and I didn't realize how
little difference it made in the end (the executing code.)

Good - thanks.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
