Return-Path: <linux-kernel-owner+w=401wt.eu-S1751963AbXAXQ24@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751963AbXAXQ24 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 11:28:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751968AbXAXQ24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 11:28:56 -0500
Received: from omx1-ext.sgi.com ([192.48.179.11]:43026 "EHLO omx1.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751963AbXAXQ2z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 11:28:55 -0500
Date: Wed, 24 Jan 2007 10:30:05 -0600
From: "Bill O'Donnell" <billodo@sgi.com>
To: KaiGai Kohei <kaigai@kaigai.gr.jp>, "Serge E. Hallyn" <serue@us.ibm.com>,
       Chris Friedhoff <chris@friedhoff.org>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [PATCH] Implement file posix capabilities
Message-ID: <20070124163004.GA15979@sgi.com>
References: <20061127170740.GA5859@sergelap.austin.ibm.com> <20061129112848.8e48267e.chris@friedhoff.org> <20061129204013.GA7228@sgi.com> <20061130180502.GA20345@sgi.com> <20061130225707.GA23379@sergelap.austin.ibm.com> <4570F373.5090608@kaigai.gr.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4570F373.5090608@kaigai.gr.jp>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm in the process of testing the (backported) capabilities patch 
and Kaigai's userspace tools on a SLES10 based x86-64 target (2.6.16).  
Chris Friedhoff's examples (http://www.friedhoff.org/fscaps.html)
run cleanly.  That said, can one expect, through the use of these
enhanced capabilities, to be able to add some finer grain 
capabilities based on a specific userid?  In Chris' ping example,
the suid is removed from /bin/ping to restrict it to root, and a 
capability added to allow any user to execute it.  Can that example
be extended to make it so only a _particular_ user can execute it?
I realize with SELinux, one could achieve the goal, but as a stopgap,
can capabilities be used to get there?
Thanks,
Bill

-- 
Bill O'Donnell
SGI
billodo@sgi.com
