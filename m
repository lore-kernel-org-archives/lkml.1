Return-Path: <linux-kernel-owner+w=401wt.eu-S1759752AbYBHOYJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759752AbYBHOYJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 09:24:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756368AbYBHOXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 09:23:53 -0500
Received: from smtp-out02.alice-dsl.net ([88.44.60.12]:31631 "EHLO
	smtp-out02.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758952AbYBHOXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 09:23:49 -0500
To: Sven Wegener <sven.wegener@stealer.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipvs: Make the synchronization interval controllable
References: <1202333990-19359-1-git-send-email-sven.wegener@stealer.net>
From: Andi Kleen <andi@firstfloor.org>
Date: 08 Feb 2008 15:23:47 +0100
In-Reply-To: <1202333990-19359-1-git-send-email-sven.wegener@stealer.net>
Message-ID: <871w7n34ss.fsf@basil.nowhere.org>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 08 Feb 2008 14:17:27.0253 (UTC) FILETIME=[551D1050:01C86A5D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sven Wegener <sven.wegener@stealer.net> writes:

> The default synchronization interval of 1000 milliseconds is too high for a
> heavily loaded director. Collecting the connection information from one second
> and then sending it out in a burst will overflow the socket buffer and lead to
> synchronization information being dropped. Make the interval controllable by a
> sysctl variable so that users can tune it.

It would be better if the defaults just worked under all circumstances.
So why not just lower the default?

Or the code could detect overflowing socket buffers and lower the 
value dynamically.

-Andi
