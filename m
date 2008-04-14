Return-Path: <linux-kernel-owner+w=401wt.eu-S1755946AbYDNLlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946AbYDNLlZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 07:41:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753158AbYDNLlS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 07:41:18 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:55168 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752704AbYDNLlR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 07:41:17 -0400
Date: Mon, 14 Apr 2008 15:40:55 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: David Fries <david@fries.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/33 replaces 14/35 and 15/35] W1: w1_slave_read_id multiple short read bug
Message-ID: <20080414114055.GA13385@2ka.mipt.ru>
References: <20080413225632.GA14058@spacedout.fries.net> <20080413231537.GF15213@spacedout.fries.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080413231537.GF15213@spacedout.fries.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David.

On Sun, Apr 13, 2008 at 06:15:37PM -0500, David Fries (david@fries.net) wrote:
> This is more to point out the bug in w1_slave_read_id, the next patch
> rewrites the routine.
> 
> w1.c 1.15
... 
> w1.c 1.16


That is what I talked about. I agree with your analysis of the problem
and I agree with fixes. But I do not agree with how you created them:
why do we ever neen 1.15 version, since immediately after that we have
1.16 which completely rewrite what was done in previous one?
This applies to the whole patchset: there are essentially several bug
fixes and several features, so separate them into several patches, which
do not collide with each other in the above way.

-- 
	Evgeniy Polyakov
