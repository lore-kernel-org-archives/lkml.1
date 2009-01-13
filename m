Return-Path: <linux-kernel-owner+w=401wt.eu-S1758141AbZAMTiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758141AbZAMTiV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 14:38:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753152AbZAMTiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 14:38:10 -0500
Received: from yx-out-2324.google.com ([74.125.44.29]:2192 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254AbZAMTiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 14:38:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=cgXpevrf5ibNnNS3dw4jAyPdxp63M4hBe98sinYHv9zAtBulGIawZNGLjckjh/744G
         GWMemdjbSkI8jSgvOti0S63TlWPOJ0DRYeOpHVppAOLmBdG2Gfxcc6YR2Qgb6SiZzRHu
         YoTFlwftFsbM2qA9mzfzoSe0chAcMwBrYBnOQ=
Message-ID: <a36005b50901131138p5372aea2ie36243a639c4796b@mail.gmail.com>
Date: Tue, 13 Jan 2009 11:38:06 -0800
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Bernd Schmidt" <bernds_cb1@t-online.de>
Subject: Re: Fix timeouts in sys_pselect7
Cc: "Arjan van de Ven" <arjan@linux.intel.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Hennerich, Michael" <Michael.Hennerich@analog.com>
In-Reply-To: <496CCF94.8050304@t-online.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <496CCF94.8050304@t-online.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2009 at 9:29 AM, Bernd Schmidt <bernds_cb1@t-online.de> wrote:
> The patch below passes it to
> core_sys_select instead of &end_time, and this appears to fix the
> problem.  Does this look like the correct approach?

Yes, that change is correct.


> Signed-off-by: Bernd Schmidt <bernd.schmidt@analog.com>

Reviewed-by: Ulrich Drepper <drepper@redhat.com>
