Return-Path: <linux-kernel-owner+w=401wt.eu-S965534AbXCATjH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965534AbXCATjH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 14:39:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965533AbXCATjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 14:39:07 -0500
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:35243 "EHLO
	netops-testserver-4.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965534AbXCATjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 14:39:06 -0500
Date: Thu, 1 Mar 2007 11:39:00 -0800
From: Paul Jackson <pj@sgi.com>
To: vatsa@in.ibm.com
Cc: menage@google.com, ebiederm@xmission.com, sam@vilain.net,
       akpm@linux-foundation.org, dev@sw.ru, xemul@sw.ru, serue@us.ibm.com,
       containers@lists.osdl.org, winget@google.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] resource control file system - aka containers on
 top of nsproxy!
Message-Id: <20070301113900.a7dace47.pj@sgi.com>
In-Reply-To: <20070301133543.GK15509@in.ibm.com>
References: <20070301133543.GK15509@in.ibm.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

vatsa wrote:
> I suspect we can make cpusets also work
> on top of this very easily.

I'm skeptical, and kinda worried.

... can you show me the code that does this?

Namespaces are not the same thing as actual resources
(memory, cpu cycles, ...).  Namespaces are fluid mappings;
Resources are scarce commodities.

I'm wagering you'll break either the semantics, and/or the
performance, of cpusets doing this.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
