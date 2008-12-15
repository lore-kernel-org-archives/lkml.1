Return-Path: <linux-kernel-owner+w=401wt.eu-S1754757AbYLOKpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757AbYLOKpt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 05:45:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752556AbYLOKpl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 05:45:41 -0500
Received: from rv-out-0506.google.com ([209.85.198.238]:23880 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbYLOKpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 05:45:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=u36GbdcjbotxSU2/EnLbnjK3sh5QusG6nDvMIkiate8bMV3FjaBRXD+sGQmYtCsFCj
         LKNWJ/OuSZ4Bc8Za/Aw1zaSeQ57Dm5JBsXhOwdA32OoIPfdYGb7OtYPJijA3C5ZcMN35
         euXch/hmmI3gjZXBgtGNS27xlo3fDGXtWzvUo=
Message-ID: <f17812d70812150245k57e4ec0due219587125aa2112@mail.gmail.com>
Date: Mon, 15 Dec 2008 18:45:39 +0800
From: "Eric Miao" <eric.y.miao@gmail.com>
To: "Jean Delvare" <khali@linux-fr.org>
Subject: Re: [PATCH] da903x: Fix section mismatch
Cc: "Samuel Ortiz" <sameo@openedhand.com>, LKML <linux-kernel@vger.kernel.org>,
       "Mike Rapoport" <mike@compulab.co.il>,
       "Eric Miao" <eric.miao@marvell.com>, "Liam Girdwood" <lrg@kernel.org>
In-Reply-To: <20081215112805.41b6cf13@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081215112805.41b6cf13@hyperion.delvare>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2008 at 6:28 PM, Jean Delvare <khali@linux-fr.org> wrote:
> da903x_remove_subdevs() can be called in case of device initialization
> error, so it shouldn't be tagged __devexit.
>

Good catch.

Acked-by: Eric Miao <eric.miao@marvell.com>
