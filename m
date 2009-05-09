Return-Path: <linux-kernel-owner+w=401wt.eu-S1753260AbZEIRol@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260AbZEIRol (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 13:44:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752191AbZEIRoc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 13:44:32 -0400
Received: from taverner.CS.Berkeley.EDU ([128.32.168.222]:57456 "EHLO
	taverner.cs.berkeley.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbZEIRob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 13:44:31 -0400
To: linux-kernel@vger.kernel.org
Path: not-for-mail
From: daw@cs.berkeley.edu (David Wagner)
Newsgroups: isaac.lists.linux-kernel
Subject: Re: [RFC] convert ftrace syscall tracer to TRACE_EVENT()
Date: Sat, 9 May 2009 17:44:32 +0000 (UTC)
Organization: University of California, Berkeley
Message-ID: <gu4fe0$ji7$1@taverner.cs.berkeley.edu>
References: <20090508210347.GA3121@redhat.com> <c62985530905090553u538f8589l984b03428713d7ef@mail.gmail.com> <20090509133306.GA20684@elte.hu> <20090509135046.GA2344@Krystal>
Reply-To: daw-news@cs.berkeley.edu (David Wagner)
NNTP-Posting-Host: taverner.cs.berkeley.edu
X-Trace: taverner.cs.berkeley.edu 1241891072 20039 128.32.168.222 (9 May 2009 17:44:32 GMT)
X-Complaints-To: news@taverner.cs.berkeley.edu
NNTP-Posting-Date: Sat, 9 May 2009 17:44:32 +0000 (UTC)
X-Newsreader: trn 4.0-test76 (Apr 2, 2001)
Originator: daw@taverner.cs.berkeley.edu (David Wagner)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers  wrote:
> I would expect to use copy_string_from_user (for strings)
> and copy_from_user for structures, because without any strings
> (especially), the trace information become much less useful.

Why isn't this racey?

(Copying from user space twice can give you two different results.)
