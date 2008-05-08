Return-Path: <linux-kernel-owner+w=401wt.eu-S1763961AbYEHPBh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763961AbYEHPBh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 11:01:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756458AbYEHPBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 11:01:25 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:56802 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756186AbYEHPBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 11:01:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=awsLZaKzSyhBEDWMFLRKohwJWZp+Iauy1X19od3KDWtcmKzt3Yzjq1D4Xua4NSaHzRMgK4iv28bkpAcJUoZ+QZ1Gq+UZ+Vw33Uq5CDkaWvfR70AMyJ0DiBL2hb+qj4fgvA18ywEJwuTaDzKka5QF0rV5aFBFn7j47+fCCpP1Gko=
Message-ID: <36ca99e90805080801p5ee91ba1w868b04429a1ac732@mail.gmail.com>
Date: Thu, 8 May 2008 17:01:05 +0200
From: "Bert Wesarg" <bert.wesarg@googlemail.com>
To: "Alexey Dobriyan" <adobriyan@gmail.com>
Subject: Re: [PATCH 1/5] Fix cpumask_scnprintf_len() misdesign
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080507221450.GA14375@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080507221450.GA14375@martell.zuzino.mipt.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 8, 2008 at 12:14 AM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> cpumask_scnprintf_len() takes "len" as an argument which is surprising,
>  If one follows call chain down it isn't length but number of bits. But
>  there is natural number of bits when talking about CPU masks -- NR_CPUS.
>  So use that.
Reported-here: http://thread.gmane.org/gmane.linux.kernel/671725

>
>  Remove 1:1 wrapper macro while I'm at it.
>
>  Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Acked-by: Bert Wesarg <bert.wesarg@googlemail.com>
