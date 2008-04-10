Return-Path: <linux-kernel-owner+w=401wt.eu-S1757193AbYDJOFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757193AbYDJOFl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 10:05:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755739AbYDJOFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 10:05:33 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:38088 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755238AbYDJOFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 10:05:33 -0400
Date: Thu, 10 Apr 2008 09:05:29 -0500
From: Paul Jackson <pj@sgi.com>
To: Mike Travis <travis@sgi.com>
Cc: mingo@elte.hu, bert.wesarg@googlemail.com, tglx@linutronix.de,
       hpa@zytor.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] cpumask: use new cpus_scnprintf function v3
Message-Id: <20080410090529.1401aa7f.pj@sgi.com>
In-Reply-To: <20080408184301.975491000@polaris-admin.engr.sgi.com>
References: <20080408184301.651388000@polaris-admin.engr.sgi.com>
	<20080408184301.975491000@polaris-admin.engr.sgi.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike wrote:
+	if (len > 1) {
+		n = type?
+			cpulist_scnprintf(buf, len-2, *mask):
+			cpumask_scnprintf(buf, len-2, *mask);

I suppose that the discussion of PATCH 1/3 applies to this code too.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
