Return-Path: <linux-kernel-owner+w=401wt.eu-S1753424AbXJIBn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424AbXJIBn7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 21:43:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752014AbXJIBnu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 21:43:50 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:12849 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469AbXJIBnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 21:43:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=eyamji4O4qEfkJsiy+3/mORiCjrJX1Tvf5zNLCLssX6xRwTySvAFS3aLf1uDr3+AVPAAQmmPqhdo1qY4rPlzYyzuMFsLayG6ka22B73lfw5KKtOwZVSeQgi4jh6V70dg4La9BlDEp9lOVCBi5LBj3GwpO+wHil8vULjMOvJDVoc=
Message-ID: <3d0408630710081843u72807765v47d4b36712b4c9b1@mail.gmail.com>
Date: Tue, 9 Oct 2007 09:43:46 +0800
From: "Yan Zheng" <yanzheng@21cn.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH]fix VM_CAN_NONLINEAR check in sys_remap_file_pages
Cc: "Randy Dunlap" <randy.dunlap@oracle.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       ltp-list@lists.sourceforge.net
In-Reply-To: <20071008105120.4e0e4a85.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3d0408630710080445j4dea115emdfe29aac26814536@mail.gmail.com>
	 <20071008100456.dbe826d0.akpm@linux-foundation.org>
	 <20071008102843.d20b56d7.randy.dunlap@oracle.com>
	 <20071008105120.4e0e4a85.akpm@linux-foundation.org>
X-Google-Sender-Auth: 05306a4331b13af7
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/10/9, Andrew Morton <akpm@linux-foundation.org>:
> Perhaps Yan Zheng can tell us what test was used to demonstrate this?

I found it by review, only do test to check remap_file_pages works
when VM_CAN_NONLINEAR flags is set.
