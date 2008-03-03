Return-Path: <linux-kernel-owner+w=401wt.eu-S1758930AbYCCQJa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758930AbYCCQJa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 11:09:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753781AbYCCQJW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 11:09:22 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:3428 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbYCCQJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 11:09:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=l9OMKwk8Wfn1VG0KFSUSu5QN3fOFPka3IMlX6uvuohzXYE/+zZsZUiD16nhI03UkPJHczOZ61O7viksIxQD9zqM9gOxsORqHde5cs4yyHra77GkpVgPeYiVbtBsVLeyFJpucL/aB9yemhPYxBciYCJ7WlQdyNQzHOzMRkRlvy0w=
Message-ID: <fe810cf0803030809n2117219ey9fcd8f57cdf68142@mail.gmail.com>
Date: Mon, 3 Mar 2008 19:09:18 +0300
From: "Alexander Belyakov" <abelyako@googlemail.com>
To: "Pavel Machek" <pavel@ucw.cz>
Subject: Re: jffs2: -ENOSPC when truncating file?!
Cc: "kernel list" <linux-kernel@vger.kernel.org>,
       linux-mtd@lists.infradead.org, "David Woodhouse" <dwmw2@infradead.org>,
       "=?UTF-8?Q?J=C3=B6rn_Engel?=" <joern@logfs.org>
In-Reply-To: <20080303121510.GD28369@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080223235742.GE2202@elf.ucw.cz>
	 <fe810cf0802242348w625a7e7bj1a5476d6c79662@mail.gmail.com>
	 <20080303121510.GD28369@elf.ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 3, 2008 at 3:15 PM, Pavel Machek <pavel@ucw.cz> wrote:
>
>  Patch is here (I whitespace-damaged it, sorry], and I've seen no
>  discussion.. should it just be applied?
>                                                                 Pavel

Being very simple workaround, this patch helps to avoid -ENOSPC bug
until better (proper) solution is found. IMO it is worth to try this
patch (at least to make sure that you are indeed dealing with the same
bug).

-a
