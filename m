Return-Path: <linux-kernel-owner+w=401wt.eu-S1755490AbYIPBVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490AbYIPBVf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 21:21:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751392AbYIPBV0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 21:21:26 -0400
Received: from qb-out-0506.google.com ([72.14.204.234]:61513 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247AbYIPBV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 21:21:26 -0400
Message-ID: <f488382f0809151821j69737e73tffd86b41de5d6cf2@mail.gmail.com>
Date: Mon, 15 Sep 2008 18:21:24 -0700
From: "Steven Noonan" <steven@uplinklabs.net>
To: "Hiroshi Shimamoto" <h-shimamoto@ct.jp.nec.com>
Subject: Re: [PATCH -tip] uaccess: fix parameters inversion for __copy_from_user_inatomic()
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <48CF061A.5060002@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48CF061A.5060002@ct.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2008 at 6:04 PM, Hiroshi Shimamoto
<h-shimamoto@ct.jp.nec.com> wrote:
> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
>
> The following patch changes to use __copy_from_user_inatomic(),
> but the passing parameters incorrect.
>
>    x86: some lock annotations for user copy paths, v3
>
>    - add annotation back to clear_user()
>    - change probe_kernel_address() to _inatomic*() method
>
> Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Thank you! This issue was causing a kernel panic on my machine when
netfilter was enabled.

- Steven
