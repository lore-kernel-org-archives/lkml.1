Return-Path: <linux-kernel-owner+w=401wt.eu-S1757212AbZKBWsk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757212AbZKBWsk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 17:48:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757015AbZKBWsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 17:48:40 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41108 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756898AbZKBWsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 17:48:39 -0500
Date: Mon, 2 Nov 2009 14:47:52 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       andrea@cpushare.com, "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Containers <containers@lists.osdl.org>,
       Daniel Lezcano <dlezcano@fr.ibm.com>,
       Pavel Emelianov <xemul@openvz.org>
Subject: Re: pidns memory leak
Message-Id: <20091102144752.71fd4a31.akpm@linux-foundation.org>
In-Reply-To: <20091102223818.GA15628@us.ibm.com>
References: <20091006040526.GA22923@us.ibm.com>
	<4ACAFD6A.3060008@fr.ibm.com>
	<20091008030828.GA18973@us.ibm.com>
	<4ACD9ECC.90508@fr.ibm.com>
	<20091009032928.GA2031@us.ibm.com>
	<4ACF381F.9050808@fr.ibm.com>
	<20091010013235.GA11904@us.ibm.com>
	<4AD2EBC7.2020109@fr.ibm.com>
	<20091014061533.GA23569@us.ibm.com>
	<20091102133326.e3dc51fb.akpm@linux-foundation.org>
	<20091102223818.GA15628@us.ibm.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Nov 2009 16:38:18 -0600
"Serge E. Hallyn" <serue@us.ibm.com> wrote:

> > This bug hasn't been fixed yet, has it?
> 
> Well Suka did trace the bug to commit 7766755a2f249e7, and posted a patch
> to revert that, acked by Eric on Oct 20.  Suka, were you going to repost
> that patch?

Ah.  OK.  Thanks.  Found it in the backlog pile.
