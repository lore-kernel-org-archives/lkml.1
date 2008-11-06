Return-Path: <linux-kernel-owner+w=401wt.eu-S1754761AbYKFJwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761AbYKFJwk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 04:52:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753411AbYKFJwb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 04:52:31 -0500
Received: from mx2.redhat.com ([66.187.237.31]:35506 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753380AbYKFJwa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 04:52:30 -0500
Message-ID: <4912BE45.8050906@redhat.com>
Date: Thu, 06 Nov 2008 11:52:05 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Eduardo Habkost <ehabkost@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Simon Horman <horms@verge.net.au>, Andrew Morton <akpm@osdl.org>,
       Haren Myneni <hbabu@us.ibm.com>, Andrey Borzenkov <arvidjaar@mail.ru>,
       mingo@redhat.com, "Rafael J. Wysocki" <rjw@sisk.pl>,
       kexec@lists.infradead.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/14] x86: disable virt on kdump and emergency_restart
References: <1225810364-8990-1-git-send-email-ehabkost@redhat.com> <49107E2C.8090803@redhat.com> <20081105144412.GD8993@redhat.com>
In-Reply-To: <20081105144412.GD8993@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> Is there a way we can prevent any other module from using virt disable
> callback incase kvm is not loaded?
>   

We can inline the kvm specific code (which will make it useful for other 
hypervisors, and remove the hook).


-- 
error compiling committee.c: too many arguments to function

