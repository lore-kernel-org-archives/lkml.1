Return-Path: <linux-kernel-owner+w=401wt.eu-S1754171AbYKNQuN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171AbYKNQuN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 11:50:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751526AbYKNQuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 11:50:00 -0500
Received: from qw-out-2122.google.com ([74.125.92.24]:33972 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345AbYKNQt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 11:49:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Xvf7sPJgX2CzUkWNYhjAp0pOq8o//UVnPMkfjfblEzsaLlw+E5bEcMllHwgS01fgqu
         HOJ9/LmLCQ8A7KyUL/muEdmidNGKh9WQ/zinZmDIos261Pb2BS9DWUgGT7eCdu7S2IXf
         FfhBnwIOvMGEL9aAT13ZnuovagfQhycKs1I7Q=
Message-ID: <c384c5ea0811140849x9f6df35kaa36ff7ce2192ddf@mail.gmail.com>
Date: Fri, 14 Nov 2008 17:49:58 +0100
From: "Leon Woestenberg" <leon.woestenberg@gmail.com>
To: "Michael Halcrow" <mhalcrow@us.ibm.com>
Subject: Re: [PATCH] eCryptfs: Allocate up to two scatterlists for crypto ops on keys
Cc: stable@kernel.org, linux-kernel@vger.kernel.org, pjssilva@ime.usp.br,
       akpm@linux-foundation.org, dustin.kirkland@gmail.com,
       sandeen@redhat.com
In-Reply-To: <20081114164053.GC6624@halcrowt61p.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081114164053.GC6624@halcrowt61p.austin.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Nov 14, 2008 at 5:40 PM, Michael Halcrow <mhalcrow@us.ibm.com> wrote:
>
> -       sg_init_table(&dst_sg, 1);
> -       sg_init_table(&src_sg, 1);

Why did you remove the inits?

With self-checking enabled in the kernel, sg accessor functions will
check on proper initialization and BUGON().

It might be your use-case would not hit this, as it seems not to use
sg_ macro's much.

Regards,
-- 
Leon
