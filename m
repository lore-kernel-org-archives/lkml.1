Return-Path: <linux-kernel-owner+w=401wt.eu-S1764121AbYEHO7t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764121AbYEHO7t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 10:59:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763558AbYEHO7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 10:59:23 -0400
Received: from wx-out-0506.google.com ([66.249.82.228]:14520 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763499AbYEHO7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 10:59:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CXDQXe4hxG4gzdWH6FvvL24M+txbNGV/I/l5j8o84Lc4k1sC7FFiL0fu1lVq5bTgNMpJ8WwsdbsH0wzVtNMblDct7UB37FLRVEWua3Wyh+H6fk1KUxjKCw4ZdrnOtjn4wMPLVESg9xspzs2qqa9tnOZnlkwZiV0FJn4B8GafMBU=
Message-ID: <36ca99e90805080759p4ded1d6cn58ad059ed97d33e4@mail.gmail.com>
Date: Thu, 8 May 2008 16:59:18 +0200
From: "Bert Wesarg" <bert.wesarg@googlemail.com>
To: "Alexey Dobriyan" <adobriyan@gmail.com>
Subject: Re: [PATCH 2/5] Fix bitmap_scnprintf_len()
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, travis@sgi.com
In-Reply-To: <20080507222601.GB14375@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080507222601.GB14375@martell.zuzino.mipt.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 8, 2008 at 12:26 AM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> bitmap_scnprintf_len() returns 36 (thirty six) for NR_CPUS=2 which is
>  ridiculous. So, rewrite the whole thing. Fixed version allows correct
>  seq_bitmap/seq_cpumask.
Reported-here: http://thread.gmane.org/gmane.linux.kernel/671725

>
>  Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Acked-by: Bert Wesarg <bert.wesarg@googlemail.com>
