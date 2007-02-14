Return-Path: <linux-kernel-owner+w=401wt.eu-S932433AbXBNS2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932433AbXBNS2e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 13:28:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932435AbXBNS2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 13:28:34 -0500
Received: from cantor.suse.de ([195.135.220.2]:34085 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932433AbXBNS2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 13:28:33 -0500
From: Andi Kleen <ak@suse.de>
To: Jeff Dike <jdike@addtoit.com>
Subject: Re: [PATCH] x86_64 ptrace32 needs PTRACE_OLDSETOPTIONS
Date: Wed, 14 Feb 2007 19:28:09 +0100
User-Agent: KMail/1.9.5
Cc: akpm@osdl.org, patches@x86-64.org, linux-kernel@vger.kernel.org
References: <20070214175539.GD5801@ccure.user-mode-linux.org>
In-Reply-To: <20070214175539.GD5801@ccure.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702141928.09771.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 February 2007 18:55, Jeff Dike wrote:
> x86_64 ptrace32 needs to support PTRACE_OLDSETOPTIONS.  This patch
> just converts the PTRACE_OLDSETOPTIONS request to PTRACE_SETOPTIONS
> and falls through to the sys_ptrace call.

Hmm, why do we have this at all if it's the same as plain SETOPTIONS ?

-Andi
