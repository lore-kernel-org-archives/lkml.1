Return-Path: <linux-kernel-owner+w=401wt.eu-S932617AbZAQUtm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932617AbZAQUtm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 15:49:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764236AbZAQUt2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 15:49:28 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:43430 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752942AbZAQUt1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 15:49:27 -0500
Date: Sat, 17 Jan 2009 12:46:11 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: ebiederm@xmission.com, roland@redhat.com, bastian@waldi.eu.org,
       daniel@hozac.com, xemul@openvz.org, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7][v6] Container-init signal semantics
Message-ID: <20090117204611.GA12283@us.ibm.com>
References: <20090107074558.GA27881@us.ibm.com> <20090111060452.GA9014@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090111060452.GA9014@redhat.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov [oleg@redhat.com] wrote:
| Eric, Roland, what do you think ?
| 
| The whole series looks good to me. I think it adds minimal
| complications to solove the problem.

Thanks Oleg.

I made a small style update - basically removed the helpers
siginfo_from_user() and siginfo_from_ancestor_ns() and moved their
logic into send_signal() (merged patch 4 and 5 from [v6] patchset). 

Also added a patch to update /proc/pid/status to include SIG_DFL
signals and removed a pending todo for the patchset.

Roland, Eric, Daniel, Bastian, can you please comment on the [v7]
patchset ?

Thanks,

Sukadev
