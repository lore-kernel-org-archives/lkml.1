Return-Path: <linux-kernel-owner+w=401wt.eu-S1760157AbYHRTX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760157AbYHRTX3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 15:23:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754197AbYHRTXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 15:23:20 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38225 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753876AbYHRTXT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 15:23:19 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1219042537-13839-1-git-send-email-andi@firstfloor.org>
References: <1219042537-13839-1-git-send-email-andi@firstfloor.org>
To: "Andi Kleen" <andi@firstfloor.org>
Cc: dhowells@redhat.com, torvalds@osdl.org, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] Fix security.h compilation with !CONFIG_SECURITY
X-Mailer: MH-E 8.0.3+cvs; nmh 1.3; GNU Emacs 23.0.50
Date: Mon, 18 Aug 2008 20:22:14 +0100
Message-ID: <4138.1219087334@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> wrote:

>  static inline int security_ptrace_traceme(struct task_struct *child)

This should be parent, not child.

David
