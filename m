Return-Path: <linux-kernel-owner+w=401wt.eu-S965876AbXCLONP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965876AbXCLONP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 10:13:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965881AbXCLONP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 10:13:15 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:37149 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965876AbXCLONN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 10:13:13 -0400
Date: Mon, 12 Mar 2007 19:49:05 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Paul Jackson <pj@sgi.com>
Cc: sekharan@us.ibm.com, ckrm-tech@lists.sourceforge.net, xemul@sw.ru,
       linux-kernel@vger.kernel.org, rohitseth@google.com,
       ebiederm@xmission.com, mbligh@google.com, winget@google.com,
       containers@lists.osdl.org, serue@us.ibm.com, menage@google.com,
       dev@sw.ru, devel@openvz.org
Subject: Re: [ckrm-tech] [PATCH 1/7] containers (V7): Generic container system abstracted from cpusets code
Message-ID: <20070312141905.GA24742@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070212081521.808338000@menage.corp.google.com> <20070212085104.130746000@menage.corp.google.com> <20070307122117.GB2336@in.ibm.com> <6599ad830703071250p6c92a357g51391a23ee3d78d8@mail.gmail.com> <20070308103808.GH6504@in.ibm.com> <20070311123843.a16a1555.pj@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070311123843.a16a1555.pj@sgi.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 11, 2007 at 12:38:43PM -0700, Paul Jackson wrote:
> The primary reason for the cpuset double locking, as I recall, was because
> cpusets needs to access cpusets inside the memory allocator.  

"needs to access cpusets" - can you be more specific?

Being able to safely walk cpuset->parent list - is it the only access
you are talking of or more?

-- 
Regards,
vatsa
