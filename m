Return-Path: <linux-kernel-owner+w=401wt.eu-S1756053AbZGPM1B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053AbZGPM1B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 08:27:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755944AbZGPM1A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 08:27:00 -0400
Received: from one.firstfloor.org ([213.235.205.2]:50466 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755894AbZGPM07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 08:26:59 -0400
To: Sage Weil <sage@newdream.net>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/20] ceph: Ceph distributed file system client v0.10
From: Andi Kleen <andi@firstfloor.org>
References: <1247693090-27796-1-git-send-email-sage@newdream.net>
Date: Thu, 16 Jul 2009 14:26:53 +0200
In-Reply-To: <1247693090-27796-1-git-send-email-sage@newdream.net> (Sage Weil's message of "Wed, 15 Jul 2009 14:24:30 -0700")
Message-ID: <87hbxcx182.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sage Weil <sage@newdream.net> writes:

> This is v0.10 of the Ceph distributed file system client.
>
> Changes since v0.9:
>  - fixed unaligned memory access (thanks for heads up to Stefan Richter)
>  - a few code cleanups
>  - MDS reconnect and op replay bugfixes.  (The main milestone here is
>    stable handling of MDS server failures and restarts, tested by
>    running various workloads with the servers in restart loops.)
>
> What would people like to see for this to be merged into fs/?

Some more comments in the code probably wouldn't help. e.g. each
file should have some description at the top what it does.

What I always wonder with new complex networking protocols 
(which ceph essentially is): has there been some auditing/testing
what happens when a server feeds unexpected/out of bounds data
to the client? e.g. a security audit would be good. Otherwise
you might end up with remote exploits.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
