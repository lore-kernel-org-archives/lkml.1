Return-Path: <linux-kernel-owner+w=401wt.eu-S1765363AbXGQIIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765363AbXGQIIx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 04:08:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753135AbXGQIIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 04:08:40 -0400
Received: from nz-out-0506.google.com ([64.233.162.238]:57579 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757304AbXGQIIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 04:08:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Ckf5l/HDEPEAKTXxRGdl4xyOX1BoLgmUDDtbcVWhdnG9JE6I7/PAlccXtsK9Nq2EhmMkZvnz0cL0vhoSDwQiLnsr/lP+YrDog7lXkd9Pbm6kk9ojnOLMWLnwL3/Nj9r5VJakRutQGeI/ySxcfM0RhBr43r9LP8gCDrPbwBdfdIM=
Message-ID: <84144f020707170108v64f26bfbjb8ce4c6ba69266d0@mail.gmail.com>
Date: Tue, 17 Jul 2007 11:08:37 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Al Viro" <viro@ftp.linux.org.uk>
Subject: Re: [PATCH] um_kmalloc() remnants
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, jdike@addtoit.com
In-Reply-To: <E1IAhoN-0001iw-Ul@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <E1IAhoN-0001iw-Ul@ZenIV.linux.org.uk>
X-Google-Sender-Auth: 251329746df37670
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/17/07, Al Viro <viro@ftp.linux.org.uk> wrote:
> -               pri->compiled = um_kmalloc(sizeof(struct bpf_program));
> +               pri->compiled = kmalloc(sizeof(struct bpf_program), UM_GFP_KERNEL);

GFP_KERNEL?
