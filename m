Return-Path: <linux-kernel-owner+w=401wt.eu-S1752453AbZLRHZz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453AbZLRHZz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 02:25:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751521AbZLRHZy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 02:25:54 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:56477 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440AbZLRHZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 02:25:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=kiYi7ZwfXNAuLNhm10aqazryOiyzaqq+5VCmtjP0ARy4IjWueqdtJ1k3mXqmtMbSAX
         bhijRrFkczWphInBpAtHSXD+BtloS9f/ITM8JI0XpHFonq+dXsppGkO7EuaLFjZkq0nk
         l0cEqzRiMe7ZEXEKpg+nR9oMKgU6IrS9WiG7o=
MIME-Version: 1.0
In-Reply-To: <4B2AFF4C.5010100@ct.jp.nec.com>
References: <b6fcc0a0912170031u162b7f56kf9f6adc23e24278c@mail.gmail.com>
	 <4B2AFF4C.5010100@ct.jp.nec.com>
Date: Fri, 18 Dec 2009 09:25:51 +0200
Message-ID: <b6fcc0a0912172325i34d214d3r11b3bfae7381547f@mail.gmail.com>
Subject: Re: revert "config FS_JOURNAL_INFO"
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/09, Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:
> So we never allow to make memory usage small with providing an option
> to remove unused area, right?

We certainly allow this if it results in zero loss in functionality.

> If I want to reduce memory usage by this way, should I keep
> this kind of patches out of tree?

Certainly nobody can prohibit you from keeping patch out of tree.
But if you want something mainlinable, moving ->journal_info
to fs-specific data structures should do the trick. Or something.
