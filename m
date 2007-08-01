Return-Path: <linux-kernel-owner+w=401wt.eu-S1762866AbXHAJ7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762866AbXHAJ7T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 05:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753222AbXHAJ7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 05:59:12 -0400
Received: from ns.suse.de ([195.135.220.2]:56325 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601AbXHAJ7L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 05:59:11 -0400
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] Simple Performance Counters: x86_64 support
References: <11859243121617-git-send-email-clameter@sgi.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 01 Aug 2007 12:53:45 +0200
In-Reply-To: <11859243121617-git-send-email-clameter@sgi.com>
Message-ID: <p73ir7zplty.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter <clameter@sgi.com> writes:

> Export cycles_to_ns (after renaming the cycles_2_ns to cycles_to_ns to be
> conforming to other arches).

This function is broken in some cases (e.g Opteron with powernow or
AMD dual core or older Intel systems) and going away.  The TSCs tick
with different frequencies on different CPU there. In general i would
recommend to only report cycles.

-Andi
