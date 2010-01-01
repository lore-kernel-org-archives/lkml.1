Return-Path: <linux-kernel-owner+w=401wt.eu-S1752042Ab0AAWFe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042Ab0AAWFe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jan 2010 17:05:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751502Ab0AAWFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jan 2010 17:05:33 -0500
Received: from toccata.ens-lyon.org ([140.77.166.68]:35418 "EHLO
	toccata.ens-lyon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500Ab0AAWFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jan 2010 17:05:32 -0500
Date: Fri, 1 Jan 2010 23:05:29 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Stefani Seibold <stefani@seibold.net>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] proc: revert to show stack information in /proc/{pid}/status
Message-ID: <20100101220529.GL4620@const>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Stefani Seibold <stefani@seibold.net>,
	KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
	LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Alexey Dobriyan <adobriyan@gmail.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>
References: <20091231231051.1A1B.A69D9226@jp.fujitsu.com> <1262274494.14143.7.camel@wall-e> <20100101155630.1A1E.A69D9226@jp.fujitsu.com> <1262358616.11460.18.camel@wall-e>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1262358616.11460.18.camel@wall-e>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefani Seibold, le Fri 01 Jan 2010 16:10:16 +0100, a écrit :
> But ps is not a performance critical application nor a cat
> /proc/*/status!

Errr, maybe not so much as some other operations, but a lot of tools use
them, so it's really worth considering it.

Samuel
