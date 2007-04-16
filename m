Return-Path: <linux-kernel-owner+w=401wt.eu-S1030802AbXDPQB5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030802AbXDPQB5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 12:01:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030800AbXDPQB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 12:01:57 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:33783 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030795AbXDPQB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 12:01:56 -0400
To: ebiederm@xmission.com
CC: linuxram@us.ibm.com, linux-fsdevel@vger.kernel.org, viro@ftp.linux.org.uk,
       containers@lists.osdl.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-reply-to: <m18xcsl3yc.fsf@ebiederm.dsl.xmission.com>
Subject: Re: [Devel] Re: [patch 05/10] add "permit user mounts in new namespace" clone flag
References: <20070412164541.580374744@szeredi.hu>
	<20070412164620.588752236@szeredi.hu>
	<20070412203208.GG27772@sergelap.austin.ibm.com>
	<m1mz1cq3v6.fsf@ebiederm.dsl.xmission.com>
	<1176713221.9488.17.camel@ram.us.ibm.com>
	<E1HdNZn-0006i9-00@dorka.pomaz.szeredi.hu>
	<1176716941.9488.57.camel@ram.us.ibm.com>
	<E1HdNwV-0006l2-00@dorka.pomaz.szeredi.hu> <m18xcsl3yc.fsf@ebiederm.dsl.xmission.com>
Message-Id: <E1HdTag-0007bd-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 16 Apr 2007 17:58:06 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > That depends.  Current patches check the "unprivileged submounts
> > allowed under this mount" flag only on the requested mount and not on
> > the propagated mounts.  Do you see a problem with this?
> 
> I think privileges of this sort should propagate.  If I read what you
> just said correctly if I have a private mount namespace I won't be able
> to mount anything unless when it was setup the unprivileged submount
> command was explicitly set.

By design yes.  Why is that a problem?

Miklos
