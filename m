Return-Path: <linux-kernel-owner+w=401wt.eu-S1756090AbYAWSQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090AbYAWSQ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 13:16:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753412AbYAWSQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 13:16:20 -0500
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:38111 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293AbYAWSQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 13:16:19 -0500
Date: Wed, 23 Jan 2008 21:08:28 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Andrea Righi <righiandr@users.sourceforge.net>
Cc: Naveen Gupta <ngupta@google.com>, Jens Axboe <jens.axboe@oracle.com>,
       Paul Menage <menage@google.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [PATCH] cgroup: limit block I/O bandwidth
Message-ID: <20080123153828.GB12333@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Mail-Followup-To: Andrea Righi <righiandr@users.sourceforge.net>,
	Naveen Gupta <ngupta@google.com>,
	Jens Axboe <jens.axboe@oracle.com>, Paul Menage <menage@google.com>,
	Dhaval Giani <dhaval@linux.vnet.ibm.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Pavel Emelyanov <xemul@openvz.org>
References: <4791DC2C.9090405@users.sourceforge.net> <4793507B.6040706@users.sourceforge.net> <20080120143239.GS6258@kernel.dk> <47936BC1.9060805@users.sourceforge.net> <20080120160651.GU6258@kernel.dk> <4793E047.1000602@users.sourceforge.net> <2846be6b0801221102y2ad297e2u2f9df06e33b72162@mail.gmail.com> <47967805.4060307@users.sourceforge.net> <2846be6b0801221717j41984f93v920d271b948d39be@mail.gmail.com> <47975C0F.3010609@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <47975C0F.3010609@users.sourceforge.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrea Righi <righiandr@users.sourceforge.net> [2008-01-23 16:23:59]:

> Probably tracking who dirtied the pages would be the best approach, but
> we want also to reduce the overhead of this tracking. So, we should find
> a smart way to track which cgroup dirtied the pages and then only when
> the i/o scheduler dispatches the write requests of those pages, account
> the i/o operations to the opportune cgroup. In this way throttling could
> be done probably in __set_page_dirty() as well.
>

I think the OpenVZ controller works that way.
 
> -Andrea

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
