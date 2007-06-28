Return-Path: <linux-kernel-owner+w=401wt.eu-S932299AbXF1WFI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932299AbXF1WFI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 18:05:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763202AbXF1WE5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 18:04:57 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:49677 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763343AbXF1WEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 18:04:55 -0400
Date: Fri, 29 Jun 2007 03:43:22 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: "Paul Menage" <menage@google.com>
Cc: "William Lee Irwin III" <wli@holomorphy.com>, vatsa@in.ibm.com,
       ckrm-tech@lists.sourceforge.net, balbir@in.ibm.com, haveblue@us.ibm.com,
       xemul@sw.ru, dev@sw.ru, rohitseth@google.com, pj@sgi.com,
       devel@openvz.org, ebiederm@xmission.com, mbligh@google.com,
       containers@lists.osdl.org, serue@us.ibm.com,
       Andrew Morton <akpm@linux-foundation.org>, svaidy@linux.vnet.ibm.com,
       cpw@sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [ckrm-tech] [PATCH 00/10] Containers(V10): Generic Process Containers
Message-ID: <20070628221322.GA3146@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20070529130104.461765000@menage.corp.google.com> <20070530001455.45cf1dc5.akpm@linux-foundation.org> <20070530073959.GC6909@holomorphy.com> <6599ad830706281427m36f5b0eft7a677cf0feada663@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6599ad830706281427m36f5b0eft7a677cf0feada663@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 28, 2007 at 05:27:25PM -0400, Paul Menage wrote:
> So maybe this would be better handled in userspace? Have a daemon
> listing on a process connector socket, and move processes between
> containers based on notifications from the connector and user-defined
> rules.
> 
> We'd probably also want to add some new connector events, such as
> PROC_EVENT_PGRP, and PROC_EVENT_SID

Yep, this is what I did to test fair-user scheduling on top of my
patches.

Dhaval has a working program, which listens for UID change events and
moves the task to approp. container. I will review that and have it
posted soon.

-- 
Regards,
vatsa
