Return-Path: <linux-kernel-owner+w=401wt.eu-S1753736AbXDMRVy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736AbXDMRVy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 13:21:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753740AbXDMRVy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 13:21:54 -0400
Received: from gw.goop.org ([64.81.55.164]:51747 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753647AbXDMRVy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 13:21:54 -0400
Message-ID: <461FBC0D.5060603@goop.org>
Date: Fri, 13 Apr 2007 10:21:17 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH mm] fix i386 get_gate_vma oops
References: <Pine.LNX.4.64.0704131714160.3687@blonde.wat.veritas.com>
In-Reply-To: <Pine.LNX.4.64.0704131714160.3687@blonde.wat.veritas.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> Fix oops from i386-make-compat_vdso-runtime-selectable.patch.
>
> Even mingetty at system startup finds it easy to trigger an oops
> while reading /proc/PID/maps: though it has a good hold on the mm
> itself, that cannot stop exit_mm() from resetting tsk->mm to NULL.
>
> (It is usually show_map()'s call to get_gate_vma() which oopses,
> and I expect we could change that to check priv->tail_vma instead;
> but no matter, even m_start()'s call just after get_task_mm() is racy.)
>
> Signed-off-by: Hugh Dickins <hugh@veritas.com>
>   
Hm, OK.

Acked-by: Jeremy Fitzhardinge <jeremy@xensource.com>

    J
