Return-Path: <linux-kernel-owner+w=401wt.eu-S1030383AbXDDDoH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030383AbXDDDoH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 23:44:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030384AbXDDDoH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 23:44:07 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:52632 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030383AbXDDDoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 23:44:05 -0400
Date: Tue, 3 Apr 2007 20:44:02 -0700
From: Paul Jackson <pj@sgi.com>
To: vatsa@in.ibm.com
Cc: menage@google.com, sekharan@us.ibm.com, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, xemul@sw.ru, containers@lists.osdl.org,
       ebiederm@xmission.com, mbligh@google.com, winget@google.com,
       rohitseth@google.com, serue@us.ibm.com, dev@sw.ru, devel@openvz.org
Subject: Re: [ckrm-tech] [PATCH 7/7] containers (V7): Container interface to
 nsproxy subsystem
Message-Id: <20070403204402.ec6a5085.pj@sgi.com>
In-Reply-To: <20070404030756.GA9008@in.ibm.com>
References: <20070403153220.GA24946@sergelap.austin.ibm.com>
	<6599ad830704030845p654cf8dh65ccdc46c92d3688@mail.gmail.com>
	<20070403164615.GJ2456@in.ibm.com>
	<6599ad830704030952r5c295f3ap6e366de31dab2ccb@mail.gmail.com>
	<20070403171155.GK2456@in.ibm.com>
	<6599ad830704031010i5418abf1o12b11334cde4d2c5@mail.gmail.com>
	<20070403173048.GL2456@in.ibm.com>
	<6599ad830704031030n2311bcd7hca9f34e64c66337f@mail.gmail.com>
	<20070403175101.GN2456@in.ibm.com>
	<6599ad830704031049v7fad0a83q3c24211cf44d71d6@mail.gmail.com>
	<20070404030756.GA9008@in.ibm.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

vatsa wrote:
> User space queries like "what is the cpuset to which this task belongs",
> where the answer needs to be something of the form "/dev/cpuset/C1"?

I think that answer should be of the form "/C1", and not include the
cpuset file system mount point ... though for the purposes of the
present thread, this is probably not an interesting detail.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
