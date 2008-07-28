Return-Path: <linux-kernel-owner+w=401wt.eu-S1760111AbYG1Qum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760111AbYG1Qum (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 12:50:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751805AbYG1Qre
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 12:47:34 -0400
Received: from smtp-out.google.com ([216.239.33.17]:40916 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759279AbYG1Qrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 12:47:33 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=BDCtR/2UODfU1G59PG0GbEcriJlQCAMTTA7Li8dBSjVhg+m5P0Xj8y1TsuR3e9xh8
	NdYg5Fv/5Qax950aB2AXQ==
Message-ID: <6599ad830807280947j21fda44ajd51ce1dd523d9472@mail.gmail.com>
Date: Mon, 28 Jul 2008 09:47:26 -0700
From: "Paul Menage" <menage@google.com>
To: "Bill Davidsen" <davidsen@tmr.com>
Subject: Re: How to disable group scheduler correctly?
Cc: luis6674@yahoo.com, linux-kernel@vger.kernel.org
In-Reply-To: <488D03A9.4020103@tmr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <842240.12654.qm@web53310.mail.re2.yahoo.com>
	 <488D03A9.4020103@tmr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 27, 2008 at 4:24 PM, Bill Davidsen <davidsen@tmr.com> wrote:
> Would be nice to have a clean way to do this at runtime, so you could run a
> distribution kernel and just avoid the group part of the scheduling.

If the cgroups scheduler is enabled but you don't actually create any
cpu scheduler cgroups, then you're just scheduling across a single
group that contains all processes/threads. Is that distinguishable
from not having group scheduling at all?

Paul
