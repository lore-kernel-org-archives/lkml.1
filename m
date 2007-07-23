Return-Path: <linux-kernel-owner+w=401wt.eu-S1760101AbXGWPBn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760101AbXGWPBn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 11:01:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755302AbXGWPBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 11:01:34 -0400
Received: from mail.suse.de ([195.135.220.2]:37503 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755030AbXGWPBd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 11:01:33 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH] [2/11] x86: Fix alternatives and kprobes to remap write-protected kernel text
Date: Mon, 23 Jul 2007 17:01:28 +0200
User-Agent: KMail/1.9.6
Cc: jbeulich@novell.com, jeremy@goop.org, zach@vmware.com, patches@x86-64.org,
       linux-kernel@vger.kernel.org
References: <20070720532.949522000@suse.de> <20070720153246.6597614E79@wotan.suse.de> <20070723144603.GA11854@Krystal>
In-Reply-To: <20070723144603.GA11854@Krystal>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707231701.28529.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 July 2007 16:46:03 Mathieu Desnoyers wrote:

> I would recommend to prefix with __init every function that is assumed
> "safe" because executed at boot time. It would minimize the risks of
> buggy usage of these text-modification primitives. That includes
> text_poke() and a big chunk of the apply alternative code. (it should
> never be executed on a live system, except at boot time, right ?)

lock prefix patching can happen later on cpu hotplug/unplug event.

-Andi

