Return-Path: <linux-kernel-owner+w=401wt.eu-S1759009AbYAHLSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759009AbYAHLSR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 06:18:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752919AbYAHLSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 06:18:05 -0500
Received: from mx1.redhat.com ([66.187.233.31]:60321 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752439AbYAHLSE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 06:18:04 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20080107162718.GA16072@uranus.ravnborg.org>
References: <20080107162718.GA16072@uranus.ravnborg.org> <alpine.LFD.1.00.0801061410290.3148@woody.linux-foundation.org> <20080107165344.28e9f1ed@Varda>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: dhowells@redhat.com,
       Alejandro Riveira =?iso-8859-1?Q?Fern=E1ndez?= 
	<ariveira@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: smpboot_64 section mismatch warning
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Tue, 08 Jan 2008 11:17:51 +0000
Message-ID: <29505.1199791071@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


	[arch/x86/kernel/smpboot_64.c]
	void do_fork_idle(struct work_struct *work)

Needs labelling with __cpuinit.

David
