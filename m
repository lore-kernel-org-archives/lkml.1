Return-Path: <linux-kernel-owner+w=401wt.eu-S1762469AbYHHXec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762469AbYHHXec (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 19:34:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756988AbYHHXeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 19:34:06 -0400
Received: from tundra.namei.org ([65.99.196.166]:58240 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755704AbYHHXeE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 19:34:04 -0400
Date: Sat, 9 Aug 2008 09:33:34 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: David Howells <dhowells@redhat.com>
cc: Eduardo Habkost <ehabkost@redhat.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: next-20080808 fs/nfsctl.c build error
In-Reply-To: <30847.1218236306@redhat.com>
Message-ID: <alpine.LRH.1.10.0808090933210.30183@tundra.namei.org>
References: <alpine.LRH.1.10.0808090825060.29741@tundra.namei.org> <20080808171624.24ae1e10.sfr@canb.auug.org.au> <20080808172527.GB4742@blackpad> <30847.1218236306@redhat.com>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Aug 2008, David Howells wrote:

> James Morris <jmorris@namei.org> wrote:
> 
> > In any case, it seems that linux/cred.h should include linux/sched.h to 
> > provide a full definition of 'struct task_struct', so that 'current' can 
> > be dereferenced (e.g. in current_cred()).
> 
> Not good.  That makes sched.h and cred.h recursively dependent.  sched.h
> really needs splitting up, and the include dependencies need sorting.
> 
> However, for the moment I recommend the attached patch.

Applied.


-- 
James Morris
<jmorris@namei.org>
