Return-Path: <linux-kernel-owner+w=401wt.eu-S1755431AbYKTNwJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431AbYKTNwJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 08:52:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754715AbYKTNvz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 08:51:55 -0500
Received: from one.firstfloor.org ([213.235.205.2]:58162 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597AbYKTNvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 08:51:55 -0500
Date: Thu, 20 Nov 2008 15:01:49 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Alexander van Heukelum <heukelum@mailshack.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Jan Beulich <jbeulich@novell.com>,
       Ingo Molnar <mingo@elte.hu>, Glauber Costa <gcosta@redhat.com>,
       Matt Mackall <mpm@selenic.com>, Thomas Gleixner <tglx@linutronix.de>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [PATCH] x86: clean up after: move entry_64.S register saving out of the macros
Message-ID: <20081120140149.GT6703@one.firstfloor.org>
References: <1226845741-12470-2-git-send-email-heukelum@fastmail.fm> <20081117175232.GA13766@mailshack.com> <20081119001811.GA23237@mailshack.com> <20081120134011.GA3627@mailshack.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081120134011.GA3627@mailshack.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2008 at 02:40:11PM +0100, Alexander van Heukelum wrote:
> This add-on patch to x86: move entry_64.S register saving out
> of the macros visually cleans up the appearance of the code by
> introducing some basic helper macro's. 

So it's not standard assembler anymore. Welcome objdump -S !

-Andi
