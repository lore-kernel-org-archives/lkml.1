Return-Path: <linux-kernel-owner+w=401wt.eu-S965534AbXCGO1J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965534AbXCGO1J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 09:27:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965537AbXCGO1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 09:27:09 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:60380 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965534AbXCGO1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 09:27:07 -0500
Date: Wed, 7 Mar 2007 20:04:12 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: menage@google.com
Cc: akpm@osdl.org, pj@sgi.com, sekharan@us.ibm.com, dev@sw.ru, xemul@sw.ru,
       serue@us.ibm.com, ebiederm@xmission.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       rohitseth@google.com, mbligh@google.com, winget@google.com,
       containers@lists.osdl.org, devel@openvz.org
Subject: Re: [PATCH 2/7] containers (V7): Cpusets hooked into containers
Message-ID: <20070307143412.GC32105@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070212081521.808338000@menage.corp.google.com> <20070212085104.290909000@menage.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070212085104.290909000@menage.corp.google.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 12, 2007 at 12:15:23AM -0800, menage@google.com wrote:
>  /*
> @@ -913,12 +537,14 @@ static int update_nodemask(struct cpuset
>  	int migrate;
>  	int fudge;
>  	int retval;
> +	struct container *cont;

This seems to be redundant?

-- 
Regards,
vatsa
