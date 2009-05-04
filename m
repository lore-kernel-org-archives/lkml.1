Return-Path: <linux-kernel-owner+w=401wt.eu-S1757032AbZEDAXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757032AbZEDAXz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 20:23:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753955AbZEDAXq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 20:23:46 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:16316 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753822AbZEDAXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 20:23:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tOnIYTsObVKP6mVDLavddodF0GSlYCm8eAFSRdOh+wDtALr9oQP5gj+7iax6/sAHmf
         3KIEPHp/0zzdR7dKxPJe/V0g6FvxcKVCVoFBnG8dUVeAgbU93FJ8QqlS+QM1ZA5WoIxY
         q5oFKwX+ZuOwAfapwrSFZVcilig2pZHm+HJEo=
Date: Mon, 4 May 2009 04:24:31 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org, mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: Re: [PATCH] x86: ptrace debugreg checks rewrite
Message-ID: <20090504002431.GA17556@x200.localdomain>
References: <20090504001601.GL16631@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090504001601.GL16631@x200.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 04, 2009 at 04:16:01AM +0400, Alexey Dobriyan wrote:
> +static int ptrace_check_debugreg(int _32bit,
> +				 unsigned long dr0, unsigned long dr1,
> +				 unsigned long dr2, unsigned long dr3,
> +				 unsigned long dr6, unsigned long dr7)
> +{
> +	/* Breakpoint type: 00: --x, 01: -w-, 10: undefined, 11: rw- */
> +	unsigned int rw[4];
> +	/* Breakpoint length: 00: 1 byte, 01: 2 bytes, 10: 8 bytes, 11: bytes */
								        4 bytes, of course
