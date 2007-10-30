Return-Path: <linux-kernel-owner+w=401wt.eu-S1754065AbXJ3GiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065AbXJ3GiS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 02:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752771AbXJ3GiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 02:38:07 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:13460 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702AbXJ3GiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 02:38:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fwodHJctgj5NaqCXzDD7frTvtikI4crn9oVyUMlB1e/YkKTkozt/OQdcq0VSPJ+8qsyUe1GBYE7wm9x01T6/TjnFt7GPRYUwjPT55OUBg5Jtj0CNbtteIeUWeAFnYMjt1FacTWwEp6kChW0g+PlICoJs2RYdvSWQdj6VAwUntGM=
Message-ID: <91b13c310710292338o3d4bf147lcae153eca30784e8@mail.gmail.com>
Date: Tue, 30 Oct 2007 14:38:02 +0800
From: "rae l" <crquan@gmail.com>
To: "Rusty Russell" <rusty@rustcorp.com.au>
Subject: Re: [PATCH 1/5] update boot spec to 2.07
Cc: "lkml - Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "H. Peter Anvin" <hpa@zytor.com>, "Vivek Goyal" <vgoyal@in.ibm.com>,
       lguest <lguest@ozlabs.org>, "Eric W. Biederman" <ebiederm@xmission.com>
In-Reply-To: <1191368106.17826.43.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1191368052.17826.40.camel@localhost.localdomain>
	 <1191368106.17826.43.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/3/07, Rusty Russell <rusty@rustcorp.com.au> wrote:
> Proposed updates for version 2.07 of the boot protocol.  This includes:
>
...
> Signed-off-by: Jeremy Fitzhardinge < jeremy@xensource.com>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> Cc: "Eric W. Biederman" < ebiederm@xmission.com>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Vivek Goyal <vgoyal@in.ibm.com >
>
> ---
>  Documentation/i386/boot.txt    |   34
Sugguestion is you also add an entry to the header of the file
(Documentation/i386/boot.txt):

something like this:

diff --git a/Documentation/i386/boot.txt b/Documentation/i386/boot.txt
index fc49b79..645bbd7 100644
--- a/Documentation/i386/boot.txt
+++ b/Documentation/i386/boot.txt
@@ -42,6 +42,9 @@ Protocol 2.05:	(Kernel 2.6.20) Make protected mode
kernel relocatable.
 Protocol 2.06:	(Kernel 2.6.22) Added a field that contains the size of
 		the boot command line

+Protocol 2.07:	(Kernel 2.6.23) Added two fields hardware_subarch and
+		hardware_subarch_data to describe the paravirtualized
+		environment.

 **** MEMORY LAYOUT

-- 
Denis Cheng
Linux Application Developer

"One of my most productive days was throwing away 1000 lines of code."
 - Ken Thompson.
