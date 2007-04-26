Return-Path: <linux-kernel-owner+w=401wt.eu-S1752463AbXDZQbH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463AbXDZQbH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 12:31:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752674AbXDZQbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 12:31:07 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:44677 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221AbXDZQbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 12:31:05 -0400
To: serue@us.ibm.com
CC: miklos@szeredi.hu, serge@hallyn.com, hpa@zytor.com, linuxram@us.ibm.com,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org,
       linux-security-module@vger.kernel.org, ebiederm@xmission.com,
       viro@ftp.linux.org.uk, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org
In-reply-to: <20070426161929.GA6439@sergelap.austin.ibm.com>
	(serue@us.ibm.com)
Subject: Re: [patch] unprivileged mounts update
References: <E1HgjG0-0005CN-00@dorka.pomaz.szeredi.hu> <462F87EA.1000002@zytor.com> <20070425172012.GA20336@sergelap.austin.ibm.com> <m1k5w0s5y0.fsf@ebiederm.dsl.xmission.com> <20070425175609.GB20165@vino.hallyn.com> <m1647ks3dm.fsf@ebiederm.dsl.xmission.com> <20070425185244.GA20688@vino.hallyn.com> <E1HgnFH-0006gR-00@dorka.pomaz.szeredi.hu> <20070426145733.GA10078@sergelap.austin.ibm.com> <E1Hh5oQ-0000w1-00@dorka.pomaz.szeredi.hu> <20070426161929.GA6439@sergelap.austin.ibm.com>
Message-Id: <E1Hh6qi-0002LI-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 26 Apr 2007 18:29:40 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> So then as far as you're concerned, the patches which were in -mm will
> remain unchanged?

Basically yes. I've merged the update patch, which was not yet added
to -mm, did some cosmetic code changes, and updated the patch headers.

There's one open point, that I think we haven't really explored, and
that is the propagation semantics.  I think you had the idea, that a
propagated mount should inherit ownership from the parent into which
it was propagated.

That sounds good if everyone agrees?

Miklos
