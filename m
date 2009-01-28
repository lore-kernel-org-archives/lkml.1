Return-Path: <linux-kernel-owner+w=401wt.eu-S1752291AbZA1Tlt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291AbZA1Tlt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 14:41:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751120AbZA1Tli
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 14:41:38 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:52516 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbZA1Tli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 14:41:38 -0500
X-AuthUser: davidel@xmailserver.org
Date: Wed, 28 Jan 2009 11:41:16 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Chris Snook <csnook@redhat.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: if (unlikely(...)) == unnecessary?
In-Reply-To: <49809C2E.3000005@redhat.com>
Message-ID: <alpine.DEB.1.10.0901281130020.21401@alien.or.mcafeemobile.com>
References: <alpine.DEB.1.10.0901272346480.20262@alien.or.mcafeemobile.com> <49809C2E.3000005@redhat.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Jan 2009, Chris Snook wrote:

> Davide Libenzi wrote:
> > I noticed that GCC >= 3.3 (not tried the ones before) automatically branches
> > out the "if" code (and follow-through the "else" code, if there). Is that a
> > coincidence or a rule we can rely on going forward?
> 
> That's the default behavior, but there are lots of things that can cause it to
> behave differently.

Please don't keep me hanging. What are they (just a few of the "lots" 
that makes GCC follow-through "if" code)?


- Davide


