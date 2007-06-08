Return-Path: <linux-kernel-owner+w=401wt.eu-S1031088AbXFHRiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031088AbXFHRiU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 13:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764198AbXFHRiE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 13:38:04 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:50165 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759920AbXFHRiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 13:38:01 -0400
Date: Fri, 8 Jun 2007 10:37:56 -0700
From: Paul Jackson <pj@sgi.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: vatsa@in.ibm.com, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       ckrm-tech@lists.sourceforge.net, balbir@in.ibm.com, haveblue@us.ibm.com,
       xemul@sw.ru, dev@sw.ru, containers@lists.osdl.org,
       ebiederm@xmission.com, mbligh@google.com, rohitseth@google.com,
       serue@us.ibm.com, menage@google.com, svaidy@linux.vnet.ibm.com,
       cpw@sgi.com, devel@openvz.org
Subject: Re: [ckrm-tech] [PATCH 00/10] Containers(V10): Generic Process
 Containers
Message-Id: <20070608103756.4f79accc.pj@sgi.com>
In-Reply-To: <20070608143250.GA7728@vino.hallyn.com>
References: <20070604204131.GB19409@sergelap.austin.ibm.com>
	<20070604140533.65e25286.pj@sgi.com>
	<20070606223952.GB5626@sergelap.austin.ibm.com>
	<20070606154347.a155630b.pj@sgi.com>
	<20070607000559.GA19529@sergelap.austin.ibm.com>
	<20070606174609.bfa01446.pj@sgi.com>
	<20070607180158.GA936@sergelap.austin.ibm.com>
	<20070607122121.24fe6ff4.pj@sgi.com>
	<20070607201723.GA17011@sergelap.austin.ibm.com>
	<20070607150113.f020d8f8.pj@sgi.com>
	<20070608143250.GA7728@vino.hallyn.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Anyway the patch I sent is simple enough, and if users end up demanding
> the ability to better deal with exclusive cpusets, the patch will be
> simple enough to extend by changing cpuset_auto_setup(), so let's
> stick with that patch since it's your preference (IIUC).

Yeah - probably so.

    When someone gets serious about things like checkpoint, restart, and
    migrate functionality, based on this container cloning, working with
    cpusets, they will probably have to revisit this interaction with
    exclusive cpusets.

Perhaps a comment could be put in the code, saying something like the
above, so whomever does this will realize they are traveling in
unchartered territory.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
