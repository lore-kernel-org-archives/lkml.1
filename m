Return-Path: <linux-kernel-owner+w=401wt.eu-S1756135AbZHYThz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135AbZHYThz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 15:37:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756106AbZHYThy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 15:37:54 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:34556 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755303AbZHYThy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 15:37:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DWPs64jWR8KhixapP15Re6SzOmiY8BrvitimbrBTu98W/buUIFK9KHZWoOPlUlO/k6
         9NyflOpUcOZPOsj7ZxjwPaXmIvpQEKR0EA93M4EPomPXqRYSssePl5z0j4B/pKFpnJRR
         3OwInwkQ9uTwG7IhXHk2Z/qmbaF6/NNeyJzzg=
MIME-Version: 1.0
In-Reply-To: <1251227779-24347-1-git-send-email-penberg@cs.helsinki.fi>
References: <1251227779-24347-1-git-send-email-penberg@cs.helsinki.fi>
Date: Tue, 25 Aug 2009 15:37:38 -0400
Message-ID: <73c1f2160908251237i3d32b39eu8e198e56610d5724@mail.gmail.com>
Subject: Re: [PATCH] x86: Execute WP test after interrupts are enabled
From: Brian Gerst <brgerst@gmail.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@goop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is there any reason to run this test at all on Xen?  It's only needed
for real 386 and some broken 486 processors.

On Tue, Aug 25, 2009 at 3:16 PM, Pekka Enberg<penberg@cs.helsinki.fi> wrote:
> Commit 83b519e8b9572c319c8e0c615ee5dd7272856090 ("slab: setup allocators
> earlier in the boot sequence") changed the boot sequence to call
> mem_init() early. Unfortunately Xen is not prepared to handle the WP test at
> that point so we need to make the test run later.
