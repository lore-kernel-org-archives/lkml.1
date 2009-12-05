Return-Path: <linux-kernel-owner+w=401wt.eu-S1751708AbZLEFSB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751708AbZLEFSB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 00:18:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751291AbZLEFSA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 00:18:00 -0500
Received: from mail-px0-f188.google.com ([209.85.216.188]:53708 "EHLO
	mail-px0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267AbZLEFR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 00:17:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=GDqN1noXY9ZFY9okMLz+DGQFRNZmUYI3w+E5Gma3HioduibScdIGA1AQsj2LbHMNHI
         QBLstHQtQnTaA/tRQjYuVCPqVZbG/wUKEGxFVc4njkQ+F8eOLe3pwy6rE5H5XVXGoKxl
         E6b2eQEZbEQ/WyBhPaV8jw8yS+2OrgXRq+VQc=
MIME-Version: 1.0
In-Reply-To: <20091205043635.GA10777@ldl.fc.hp.com>
References: <b9df5fa10912040835k3e23702o8700d2d8ad2349a4@mail.gmail.com>
	 <20091204202709.GA32347@ldl.fc.hp.com>
	 <b9df5fa10912041753n27e60020x2dd41eb50f4608ff@mail.gmail.com>
	 <20091205043635.GA10777@ldl.fc.hp.com>
Date: Sat, 5 Dec 2009 11:18:05 +0600
Message-ID: <b9df5fa10912042118p733416ffwe21b79b1f8246f2f@mail.gmail.com>
Subject: Re: [PATCH] pci: Make pci_dev struct point to NULL.
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Alex Chiang <achiang@hp.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/5/09, Alex Chiang <achiang@hp.com> wrote:
> * Rakib Mullick <rakib.mullick@gmail.com>:
>  > On 12/5/09, Alex Chiang <achiang@hp.com> wrote:
>  > > * Rakib Mullick <rakib.mullick@gmail.com>:
>
>
> Right, so what's the problem? If the slot is not enabled, we goto
>  err_exit and return, never touching dev.
>
>
> I must be slow, because I don't understand how we might reference
>  trash.
>
Since *pdev might be uninitialized. But if we are sure that it is not
uninitialized
then it is okay.

And yes - althrough we weren't warned by the compiler.

Thanks,

>
>  Thanks,
>
> /ac
>
>
