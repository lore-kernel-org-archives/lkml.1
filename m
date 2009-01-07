Return-Path: <linux-kernel-owner+w=401wt.eu-S1761896AbZAGVKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761896AbZAGVKv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 16:10:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759943AbZAGVKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 16:10:40 -0500
Received: from one.firstfloor.org ([213.235.205.2]:46701 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753962AbZAGVKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 16:10:39 -0500
To: Michael Stone <michael@laptop.org>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: RFC: Network privilege separation.
From: Andi Kleen <andi@firstfloor.org>
References: <1231307334-9542-1-git-send-email-michael@laptop.org>
Date: Wed, 07 Jan 2009 22:10:45 +0100
In-Reply-To: <1231307334-9542-1-git-send-email-michael@laptop.org> (Michael Stone's message of "Wed,  7 Jan 2009 00:48:53 -0500")
Message-ID: <87mye2yg8a.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Stone <michael@laptop.org> writes:

> For the sake of discussion, I have written up and documented one possible
> implementation of this concept based on the idea of a new rlimit named
> RLIMIT_NETWORK in the following patch series. 
>
> I eagerly await your questions, comments, suggestions, and improvements.

At least for outgoing packets you could already do it using the netfilter
owner match and a suitable uid. I suppose that could be also extended
for incoming packets.

-Andi
-- 
ak@linux.intel.com
