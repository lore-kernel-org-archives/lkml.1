Return-Path: <linux-kernel-owner+w=401wt.eu-S1754170AbYIBGQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170AbYIBGQ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 02:16:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752813AbYIBGQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 02:16:47 -0400
Received: from smtp03.osg.ufl.edu ([128.227.74.70]:59573 "EHLO smtp.ufl.edu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752757AbYIBGQq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 02:16:46 -0400
X-Greylist: delayed 7478 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Sep 2008 02:16:46 EDT
Message-ID: <1942732773.182121220328723728.JavaMail.osg@osgjas04.cns.ufl.edu>
Date: Tue, 2 Sep 2008 00:12:03 -0400 (EDT)
From: "CHADHA,VINEET" <vineet@ufl.edu>
To: nickpiggin@yahoo.com.au
Subject: TLB evaluation for Linux
Cc: linux-kernel@vger.kernel.org, vineet@ufl.edu
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Mailer: GatorMail WebMail (http://GatorMail.sf.net/)
X-Originating-IP: 10.5.153.246 [10.5.153.246]
X-UFL-Spam-Status: hits=-3, required=5, tests=ALL_TRUSTED
X-UFL-Scanned-By: CNS Open Systems Group (http://open-systems.ufl.edu/services/smtp-relay/)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have been working to evaluate TLB performance for Linux O/S and 
virtualized workloads(such as Xen) in a Full system simulator(e.g. 
simics). While my evaluation is in nascent stage, I do notice that 
most of the IPIs in multi-core environments cause complete TLB 
Flush.

I want to evaluate cost of TLB shootdown including re-population 
vs. each entry shootdown (invlpg). While a similar study has been 
done in other kernels (e.g. L4 kernel), I am not aware if it has 
been done for Linux O/S.

Are there hooks or patches to test or evaluate TLB performance. 
Specifically, I would like to know where to make changes in Linux 
kernel to support each entry shootdown.

Questions may sound little naive, but any pointers or related work 
will be helpful to me.

Thanks in advance.

Regards,
Vineet

