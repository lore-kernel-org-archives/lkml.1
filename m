Return-Path: <linux-kernel-owner+w=401wt.eu-S1757571AbZASAyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757571AbZASAyZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 19:54:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755472AbZASAxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 19:53:05 -0500
Received: from hera.kernel.org ([140.211.167.34]:44091 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755492AbZASAxD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 19:53:03 -0500
Message-ID: <4973CEEB.6060701@kernel.org>
Date: Mon, 19 Jan 2009 09:52:59 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Brian Gerst <brgerst@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/12] x86-64: Convert irqstacks to per-cpu
References: <1232296759-2253-1-git-send-email-tj@kernel.org> <1232296759-2253-4-git-send-email-tj@kernel.org> <73c1f2160901181016t61cd1954s3ced677ab5b3b28a@mail.gmail.com> <4973BD73.6010001@kernel.org> <20090118234340.GA29450@elte.hu>
In-Reply-To: <20090118234340.GA29450@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 19 Jan 2009 00:52:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> btw., i think we could (and should) now remove pda.h altogether. The stack 
> canary percpu structure should be defined in stackprotector.h [that file 
> is available in tip/master] - and all the PDA references and accessors can 
> be removed, right?

Yeah, Brian has patches for that.  Patches 0013-0017 do exactly that.
I'm waiting for updated patches.

Thans.

-- 
tejun
