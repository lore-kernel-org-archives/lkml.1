Return-Path: <linux-kernel-owner+w=401wt.eu-S1030776AbXDPPpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030776AbXDPPpt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 11:45:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030769AbXDPPpt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 11:45:49 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:38121 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030776AbXDPPps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 11:45:48 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linuxram@us.ibm.com, linux-fsdevel@vger.kernel.org, viro@ftp.linux.org.uk,
       containers@lists.osdl.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [Devel] Re: [patch 05/10] add "permit user mounts in new namespace" clone flag
References: <20070412164541.580374744@szeredi.hu>
	<20070412164620.588752236@szeredi.hu>
	<20070412203208.GG27772@sergelap.austin.ibm.com>
	<m1mz1cq3v6.fsf@ebiederm.dsl.xmission.com>
	<1176713221.9488.17.camel@ram.us.ibm.com>
	<E1HdNZn-0006i9-00@dorka.pomaz.szeredi.hu>
	<1176716941.9488.57.camel@ram.us.ibm.com>
	<E1HdNwV-0006l2-00@dorka.pomaz.szeredi.hu>
Date: Mon, 16 Apr 2007 09:43:55 -0600
In-Reply-To: <E1HdNwV-0006l2-00@dorka.pomaz.szeredi.hu> (Miklos Szeredi's
	message of "Mon, 16 Apr 2007 11:56:15 +0200")
Message-ID: <m18xcsl3yc.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> writes:

> That depends.  Current patches check the "unprivileged submounts
> allowed under this mount" flag only on the requested mount and not on
> the propagated mounts.  Do you see a problem with this?

I think privileges of this sort should propagate.  If I read what you
just said correctly if I have a private mount namespace I won't be able
to mount anything unless when it was setup the unprivileged submount
command was explicitly set.

Eric
