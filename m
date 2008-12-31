Return-Path: <linux-kernel-owner+w=401wt.eu-S1752995AbYLaA1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995AbYLaA1T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 19:27:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751950AbYLaA1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 19:27:10 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36792 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854AbYLaA1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 19:27:09 -0500
To: Peter W Morreale <pmorreale@novell.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] pdflush fix and enhancement
From: Andi Kleen <andi@firstfloor.org>
References: <20081230231152.10427.50620.stgit@hermosa.site>
Date: Wed, 31 Dec 2008 01:28:46 +0100
In-Reply-To: <20081230231152.10427.50620.stgit@hermosa.site> (Peter W. Morreale's message of "Tue, 30 Dec 2008 16:12:29 -0700")
Message-ID: <87fxk5ur0h.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter W Morreale <pmorreale@novell.com> writes:

> The following series implements a fix for pdflush thread creation and an
> enhancement for allowing the setting of the minimum and maximun number
> of pdflush threads. 

You forgot to state why the admin should control that?

Each sysctl essentially presents a failure of the automatic tuning
algorithms of the kernel (kernel hackers admitting defeat). 

So a patch adding new ones at least needs a clear rationale what
problem it is trying to fix and why the automatic tuning cannot be
fixed instead to address this case without new knobs.

-Andi

-- 
ak@linux.intel.com
