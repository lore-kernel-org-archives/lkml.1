Return-Path: <linux-kernel-owner+w=401wt.eu-S1756136AbYDOH75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136AbYDOH75 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 03:59:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752984AbYDOH7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 03:59:47 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:63568 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750AbYDOH7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 03:59:47 -0400
To: Vitaliy Gusev <vgusev@openvz.org>
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH][NET] Fix never pruned tcp out-of-order queue
From: Andi Kleen <andi@firstfloor.org>
References: <200804142121.53860.vgusev@openvz.org>
Date: Tue, 15 Apr 2008 09:59:40 +0200
In-Reply-To: <200804142121.53860.vgusev@openvz.org> (Vitaliy Gusev's message of "Mon, 14 Apr 2008 21:21:53 +0400")
Message-ID: <87mynvtuoj.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 15 Apr 2008 07:52:54.0926 (UTC) FILETIME=[B69C9AE0:01C89ECD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vitaliy Gusev <vgusev@openvz.org> writes:

> Hello!
>
> tcp_prune_queue() doesn't prune an out-of-order queue at all.

Why are you saying this? It has code to prune the ooo queue. You're even
moving it in your patch.

You're saying that the code doesn't work? If yes why? 

-Andi
