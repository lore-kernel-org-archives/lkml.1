Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751584Ab0BHVYv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 16:24:51 -0500
Received: from tundra.namei.org ([65.99.196.166]:40237 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750802Ab0BHVYt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 16:24:49 -0500
Date: Tue, 9 Feb 2010 08:24:18 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Xiaotian Feng <dfeng@redhat.com>
cc: eparis@parisplace.org, sds@tycho.nsa.gov, paul.moore@hp.com,
       serue@us.ibm.com, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] selinux: fix memory leak in sel_make_bools
In-Reply-To: <4B6FEE80.5030202@redhat.com>
Message-ID: <alpine.LRH.2.00.1002090823290.1779@tundra.namei.org>
References: <1250151976-19399-1-git-send-email-dfeng@redhat.com> <1250215360-20871-1-git-send-email-dfeng@redhat.com> <alpine.LRH.2.00.0908141606290.12770@tundra.namei.org> <4B6FEE80.5030202@redhat.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Feb 2010, Xiaotian Feng wrote:

> On 08/14/2009 02:06 PM, James Morris wrote:
> > On Fri, 14 Aug 2009, Xiaotian Feng wrote:
> > 
> > > In sel_make_bools, kernel allocates memory for bool_pending_names[i]
> > > with security_get_bools. So if we just free bool_pending_names, those
> > > memories for bool_pending_names[i] will be leaked.
> > 
> > Thanks, applied and pushed to Linus.
> This patch is missing or dropped? I'm not seeing this patch until 2.6.33-rc7,
> thanks.

Not sure what happened to that -- I pushed it to Linus, but it's not in 
the tree for some reason.  Now applied to

git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next


-- 
James Morris
<jmorris@namei.org>
