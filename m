Return-Path: <linux-kernel-owner+w=401wt.eu-S964838AbZJJBcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964838AbZJJBcZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 21:32:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933694AbZJJBcY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 21:32:24 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:46189 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933202AbZJJBcY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 21:32:24 -0400
Date: Fri, 9 Oct 2009 18:32:35 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Daniel Lezcano <dlezcano@fr.ibm.com>
Cc: Pavel Emelianov <xemul@openvz.org>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       andrea@cpushare.com, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: pidns memory leak
Message-ID: <20091010013235.GA11904@us.ibm.com>
References: <4AC5F198.2070407@fr.ibm.com> <20091006040526.GA22923@us.ibm.com> <4ACAFD6A.3060008@fr.ibm.com> <20091008030828.GA18973@us.ibm.com> <4ACD9ECC.90508@fr.ibm.com> <20091009032928.GA2031@us.ibm.com> <4ACF381F.9050808@fr.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ACF381F.9050808@fr.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ccing  Andrea's new email id:

Daniel Lezcano [dlezcano@fr.ibm.com] wrote:
> Following your explanation I was able to reproduce a simple program  
> added in attachment. But there is something I do not understand is why  
> the leak does not appear if I do the 'lstat' (cf. test program) in the  
> pid 2 context.

Hmm, are you sure there is no leak with this test program ? If I put back
the commit (7766755a2f249e7), I do see a leak in all three data structures
(pid_2, proc_inode, pid_namespace).
