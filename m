Return-Path: <linux-kernel-owner+w=401wt.eu-S1760224AbYESUJN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760224AbYESUJN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 16:09:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764150AbYESUIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 16:08:49 -0400
Received: from ik-out-1112.google.com ([66.249.90.181]:22209 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764136AbYESUIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 16:08:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:sender;
        b=bsQ9lMXFOW1GRW8LUm1CXxQ0kW7gLRnEVks/Ptlg77RK9dQ8/9TrTkE4bqeX2N/GDIr/37Pkh4aOREbr5JH+LWq7bdn0JUFMiBc8XDTNJTkj+y8JZzFEGguvHnfYnsP7+VETFYAZafLEu7uZQUudomAx2RyUnEEsE3EH1g+3ruo=
Message-ID: <4831DE4D.7020602@users.sourceforge.net>
Date: Mon, 19 May 2008 22:08:45 +0200
From: Andrea Righi <righiandr@users.sourceforge.net>
Reply-To: righiandr@users.sourceforge.net
User-Agent: Swiftdove 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: balbir@linux.vnet.ibm.com
CC: Shailabh Nagar <nagar@watson.ibm.com>, Mark Seger <Mark.Seger@hp.com>,
       Jes Sorensen <jes@sgi.com>, Chris Sturtivant <csturtiv@sgi.com>,
       Tony Ernst <tee@sgi.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] distinct tgid/tid I/O statistics
References: <482DF0C0.6050208@users.sourceforge.net> <4831BDBA.6090609@linux.vnet.ibm.com> <4831C7E7.2090804@users.sourceforge.net>
In-Reply-To: <4831C7E7.2090804@users.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea Righi wrote:
> Balbir Singh wrote:
>>> +
>>> +    if (!whole) {
>>> +#ifdef CONFIG_TASK_XACCT
>> Can't we abstract this into a function for ease?
> 

BTW, CONFIG_TASK_IO_ACCOUNTING depends on CONFIG_TASK_XACCT, so I think
we can just remove those #ifdefs inside CONFIG_TASK_IO_ACCOUNTING.

-Andrea
