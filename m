Return-Path: <linux-kernel-owner+w=401wt.eu-S1030258AbXCFVqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030258AbXCFVqw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 16:46:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030259AbXCFVqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 16:46:52 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:16621 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030258AbXCFVqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 16:46:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=IG85egReLEiVwl4K829bSImllTlO02zkOKanrmvfoT2dd0NQbsoHjoSjQa/UO2IILS90QdPapWLT7KxdX49cKApluF2hXPxB3xVgMwxBG5LItnVj++53q3A0YovRcENdY55g3QjFTs6+QyAFDw6y7xyaTlvQq1mQBYSmLRzm8KE=
Message-ID: <9e0cf0bf0703061346q5c6ee3e8lce5d6e7a63b40ee9@mail.gmail.com>
Date: Wed, 7 Mar 2007 00:46:48 +0300
From: "Alon Bar-Lev" <alon.barlev@gmail.com>
To: alon.barlev@gmail.com, ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86_64, i386: Add command line length to boot protocol
In-Reply-To: <20070306181430.GB3151@strauss.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070306181430.GB3151@strauss.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/6/07, Bernhard Walle <bwalle@suse.de> wrote:
> +The kernel command line is a null-terminated string. The maximum
> +length can be retrieved from the field cmdline_size.  Before protocol
> +version 2.06, the maximum was 255 characters.  A string that is too
> +long will be automatically truncated by the kernel.

This is incorrect.
Since 2.02, the maximum was null terminated string truncated by kernel.

Best Regards,
Alon Bar-Lev.
