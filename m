Return-Path: <linux-kernel-owner+w=401wt.eu-S1756107AbZCDA4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107AbZCDA4W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 19:56:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752839AbZCDA4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 19:56:13 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:55295 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbZCDA4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 19:56:11 -0500
From: Dan Smith <danms@us.ibm.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: containers@lists.osdl.org, linux-s390@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] s390: Expose a constant for the number of words representing the CRs
References: <1236095764-19325-1-git-send-email-danms@us.ibm.com>
	<1236095764-19325-2-git-send-email-danms@us.ibm.com>
	<1236096494.22399.5.camel@nimitz>
Date: Tue, 03 Mar 2009 16:56:03 -0800
In-Reply-To: <1236096494.22399.5.camel@nimitz> (Dave Hansen's message of "Tue,
	03 Mar 2009 08:08:14 -0800")
Message-ID: <87d4cyrtr0.fsf@caffeine.danplanet.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DH> This doesn't do a lot of good unless it gets used in the base s390
DH> code.  Otherwise, why not just define it near its use in the c/r
DH> code?

I intended to replace all uses, but I just found one place I missed,
but I think that's it.  If you know of other places that it's used in
the s390 code, other than in compat_ptrace.h and ptrace.h please point
them out.

-- 
Dan Smith
IBM Linux Technology Center
email: danms@us.ibm.com

