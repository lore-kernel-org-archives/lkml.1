Return-Path: <linux-kernel-owner+w=401wt.eu-S1753478AbYCXDzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478AbYCXDzu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 23:55:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751723AbYCXDzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 23:55:40 -0400
Received: from smtp-out02.alice-dsl.net ([88.44.60.12]:15843 "EHLO
	smtp-out02.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618AbYCXDzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 23:55:39 -0400
To: "Kai" <epimetreus@fastmail.fm>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Serious performance regression in Wine applications and Linux 2.6.24.*
References: <1206310206.17373.1243881033@webmail.messagingengine.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 24 Mar 2008 04:55:36 +0100
In-Reply-To: <1206310206.17373.1243881033@webmail.messagingengine.com>
Message-ID: <87tziw7p3b.fsf@basil.nowhere.org>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 24 Mar 2008 03:49:00.0191 (UTC) FILETIME=[FE8AC2F0:01C88D61]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Kai" <epimetreus@fastmail.fm> writes:

> Originally, it was just about everything -- Wine itself, and most any
> app I tried to run with it.
> 
> In my most recent tests, however, it only seems to affect Age of Wonders
> II and Age of Wonders Shadow Magic, which use very similar engines.

A simple test if the scheduler is likely to blame would be to compare
context switch rates between the different kernel versions who show
differing performance. You can do that with running "vmstat 1" in
parallel and checking the "cs" column.

Another powerful but quite slow method if you can easily reproduce it
would be a full git bisect. That would identify exactly which change
introduced your problem.

-Andi
