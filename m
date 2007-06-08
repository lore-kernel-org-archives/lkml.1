Return-Path: <linux-kernel-owner+w=401wt.eu-S970924AbXFHUGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970924AbXFHUGl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 16:06:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751575AbXFHUFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 16:05:22 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:47892 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030633AbXFHUFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 16:05:19 -0400
Date: Fri, 8 Jun 2007 13:05:17 -0700
From: Paul Jackson <pj@sgi.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: menage@google.com, vatsa@in.ibm.com, linux-kernel@vger.kernel.org,
       ckrm-tech@lists.sourceforge.net, balbir@in.ibm.com, haveblue@us.ibm.com,
       xemul@sw.ru, dev@sw.ru, containers@lists.osdl.org,
       ebiederm@xmission.com, mbligh@google.com, rohitseth@google.com,
       serue@us.ibm.com, akpm@linux-foundation.org, svaidy@linux.vnet.ibm.com,
       cpw@sgi.com, devel@openvz.org, serge@hallyn.com
Subject: Re: [ckrm-tech] [PATCH 00/10] Containers(V10): Generic Process
 Containers
Message-Id: <20070608130517.8e2c5d51.pj@sgi.com>
In-Reply-To: <20070608194247.GA12671@vino.hallyn.com>
References: <20070607180158.GA936@sergelap.austin.ibm.com>
	<20070607122121.24fe6ff4.pj@sgi.com>
	<20070607201723.GA17011@sergelap.austin.ibm.com>
	<20070607150113.f020d8f8.pj@sgi.com>
	<20070608143250.GA7728@vino.hallyn.com>
	<6599ad830706080855n22612814u4805d34a295b165f@mail.gmail.com>
	<20070608160840.GA11133@vino.hallyn.com>
	<6599ad830706080916j477e08c0l8b142d9a0d832c76@mail.gmail.com>
	<20070608180837.GA5683@sergelap.austin.ibm.com>
	<6599ad830706081113g56e755c6vc5cd0fbd5c15697@mail.gmail.com>
	<20070608194247.GA12671@vino.hallyn.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Serge wrote:
> Paul (Jackson), is this comment added in cpusets close enough to what
> you were asking for?

This comment?

+ * Currently we refuse to set up the container - thereby
+ * refusing the task to be entered, and as a result refusing
+ * the sys_unshare() or clone() which initiated it - if any
+ * sibling cpusets have exclusive cpus or mem.
+ *
+ * If this becomes a problem for some users who wish to
+ * allow that scenario, then cpuset_post_clone() could be
+ * changed to grant parent->cpus_allowed-sibling_cpus_exclusive
+ * (and likewise for mems) to the new container.


Nice - thanks.


-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
