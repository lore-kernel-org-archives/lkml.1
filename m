Return-Path: <linux-kernel-owner+w=401wt.eu-S1767711AbXCJBbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767711AbXCJBbQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 20:31:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767712AbXCJBbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 20:31:16 -0500
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:47192 "EHLO
	netops-testserver-4.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1767711AbXCJBbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 20:31:15 -0500
Date: Fri, 9 Mar 2007 17:31:15 -0800
From: Paul Jackson <pj@sgi.com>
To: Herbert Poetzl <herbert@13thfloor.at>
Cc: vatsa@in.ibm.com, menage@google.com, ebiederm@xmission.com,
       winget@google.com, containers@lists.osdl.org, akpm@linux-foundation.org,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       xemul@sw.ru
Subject: Re: [PATCH 1/2] rcfs core patch
Message-Id: <20070309173115.c70aa20a.pj@sgi.com>
In-Reply-To: <20070310010041.GD3647@MAIL.13thfloor.at>
References: <20070301133543.GK15509@in.ibm.com>
	<20070301134528.GL15509@in.ibm.com>
	<m1slcg8m4f.fsf@ebiederm.dsl.xmission.com>
	<20070308101347.GA29051@in.ibm.com>
	<20070309004816.GB4506@MAIL.13thfloor.at>
	<20070309181422.GB21661@in.ibm.com>
	<20070309112547.3e82deca.pj@sgi.com>
	<20070310010041.GD3647@MAIL.13thfloor.at>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert wrote:
> personally, I'd prefer to avoid hierarchical
> structures wherever possible,

Sure - avoid them if you like.  But sometimes they work out rather
well.  And file system API's are sometimes the best fit for them.

I'm all for choosing the simplest API topology that makes sense.

But encoding higher dimension topologies into lower dimension API's,
just because they seem "simpler" results in obfuscation, convolution
and obscurity, which ends up costing everyone more than getting the
natural fit.

    "Make everything as simple as possible, but not simpler."
    --  Albert Einstein

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
