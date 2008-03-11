Return-Path: <linux-kernel-owner+w=401wt.eu-S1754390AbYCKRwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390AbYCKRwt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 13:52:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753227AbYCKRwm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 13:52:42 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:60205 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752890AbYCKRwl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 13:52:41 -0400
Date: Tue, 11 Mar 2008 20:56:29 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] signals: fold complete_signal() into send_signal/do_send_sigqueue
Message-ID: <20080311175629.GB586@tv-sign.ru>
References: <20080308151024.GA25188@tv-sign.ru> <20080311020640.DC6F326F991@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080311020640.DC6F326F991@magilla.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10, Roland McGrath wrote:
>
> This and 1-3/6 look OK to me.  But, since this one appears to be changing
> the sense of the return value from send_signal, I think you should at least
> take the opportunity to add a comment to send_signal saying clearly what
> its return conventions are.

Actually, this patch restores the meaning of the return value, it was temporary
changed by the previous cleanups in -mm tree.

With this patch send_signal() return either 0 or error, as it historically was.

Oleg.

