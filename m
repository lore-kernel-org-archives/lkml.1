Return-Path: <linux-kernel-owner+w=401wt.eu-S1753576AbYKEXKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576AbYKEXKg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 18:10:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751826AbYKEXKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 18:10:24 -0500
Received: from tundra.namei.org ([65.99.196.166]:35714 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751762AbYKEXKY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 18:10:24 -0500
Date: Thu, 6 Nov 2008 10:09:55 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Michal Schmidt <mschmidt@redhat.com>
cc: linux-kernel@vger.kernel.org, Eric Paris <eparis@redhat.com>,
       netdev@vger.kernel.org
Subject: Re: [PATCH] selinux: recognize netlink messages for 'ip addrlabel'
In-Reply-To: <20081105133506.203b48d6@leela>
Message-ID: <alpine.LRH.1.10.0811061009230.6690@tundra.namei.org>
References: <20081105133506.203b48d6@leela>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Nov 2008, Michal Schmidt wrote:

> In enforcing mode '/sbin/ip addrlabel' results in a SELinux error:
> type=SELINUX_ERR msg=audit(1225698822.073:42): SELinux:  unrecognized
> netlink message type=74 for sclass=43
> 
> The problem is missing RTM_*ADDRLABEL entries in SELinux's netlink
> message types table.
> 
> Reported in https://bugzilla.redhat.com/show_bug.cgi?id=469423
> 
> Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
> ---
>  security/selinux/nlmsgtab.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)

Applied to

git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next

-- 
James Morris
<jmorris@namei.org>
