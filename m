Return-Path: <linux-kernel-owner+w=401wt.eu-S1754762AbYAVOtw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762AbYAVOtw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 09:49:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751141AbYAVOtp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 09:49:45 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55902 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbYAVOto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 09:49:44 -0500
Subject: Re: [PATCH 0/6] IO context sharing
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, knikanth@novell.com
In-Reply-To: <1200995361-24001-1-git-send-email-jens.axboe@oracle.com>
References: <1200995361-24001-1-git-send-email-jens.axboe@oracle.com>
Content-Type: text/plain
Date: Tue, 22 Jan 2008 15:49:31 +0100
Message-Id: <1201013372.6341.19.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-01-22 at 10:49 +0100, Jens Axboe wrote:
> Hi,
> 
> Today io contexts are per-process and define the (surprise) io context
> of that process. In some situations it would be handy if several
> processes share an IO context. With syslets it's especially crucial that
> the threads working on behalf of the parent process are seen as the same
> IO context. That goes from both a fairness and performance point of
> view, since IO schedulers like AS and CFQ base decisions on what the
> IO context state is. This patchset adds support for processes sharing a
> single io context and also adds a CLONE_IO flag to denote sharing of
> IO context.

Are you planning on extending this to a hierarchical CFQ for cgroups, or
just giving the IO context to a cgroup?



