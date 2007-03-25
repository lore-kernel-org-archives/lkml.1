Return-Path: <linux-kernel-owner+w=401wt.eu-S1753478AbXCYIOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478AbXCYIOd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 04:14:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753480AbXCYIOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 04:14:33 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:37030 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478AbXCYIOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 04:14:32 -0400
Date: Sun, 25 Mar 2007 13:51:44 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Paul Jackson <pj@sgi.com>
Cc: sekharan@us.ibm.com, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, xemul@sw.ru, rohitseth@google.com,
       ebiederm@xmission.com, mbligh@google.com, winget@google.com,
       containers@lists.osdl.org, serue@us.ibm.com, menage@google.com,
       dev@sw.ru, devel@openvz.org
Subject: Re: [ckrm-tech] [PATCH 1/7] containers (V7): Generic container system abstracted from cpusets code
Message-ID: <20070325082144.GH11794@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070212081521.808338000@menage.corp.google.com> <20070212085104.130746000@menage.corp.google.com> <20070324150505.GB9475@in.ibm.com> <20070324122559.11b9ba34.pj@sgi.com> <20070325004529.GD11794@in.ibm.com> <20070324184128.e8b34a3e.pj@sgi.com> <20070325022816.GE11794@in.ibm.com> <20070325041602.GF11794@in.ibm.com> <20070324224348.eeb96048.pj@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070324224348.eeb96048.pj@sgi.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 24, 2007 at 10:43:48PM -0700, Paul Jackson wrote:
> I'm unsure here, but this 'tsk->cpuset == cs' test feels fragile to me.
> 
> How about a bit earlier in attach_task(), right at the point we overwrite the
> victim tasks cpuset pointer, we decrement the count on the old cpuset, and if
> it went to zero, remember that we'll need to release it, once we've dropped
> some locks:

Looks neater. Will adopt this when I send the patch. Thanks.

-- 
Regards,
vatsa
