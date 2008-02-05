Return-Path: <linux-kernel-owner+w=401wt.eu-S1753996AbYBEOJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996AbYBEOJV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 09:09:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751835AbYBEOJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 09:09:14 -0500
Received: from rn-out-0910.google.com ([64.233.170.185]:7545 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708AbYBEOJN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 09:09:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=ZtKFhtEyxCbWxWSschJbtTWkL6LJfPmsvpvigyNLI6iKe5Nji4hUc9SlsZZFGI/oi9A0KPJGFPjpx2DuxIsbIaIwBrrjmyLSMoGroPU3UMQij4AUyQq9bmYBrlkeYtdRe1DVc9HLNcL/9/0bz1Sod43sQ/UhyVuuYK8gtznBMcw=
Date: Tue, 5 Feb 2008 15:04:35 +0100
From: Alejandro Riveira =?UTF-8?B?RmVybsOhbmRleg==?= 
	<ariveira@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jeff Layton <jlayton@redhat.com>, Guenter Kukkukk <linux@kukkukk.com>,
       samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
       Adrian Bunk <bunk@kernel.org>, sfrench@samba.org
Subject: Re: [2.6 patch] remove smbfs
Message-ID: <20080205150435.474178aa@Varda>
In-Reply-To: <20080205001805.0ea014f3.akpm@linux-foundation.org>
References: <20080128220835.GF8767@does.not.exist>
	<200801302216.13788.linux@kukkukk.com>
	<20080130174103.17ff8197@tleilax.poochiereds.net>
	<20080205001805.0ea014f3.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Tue, 5 Feb 2008 00:18:05 -0800
Andrew Morton <akpm@linux-foundation.org> escribió:


>  	struct smb_fattr root;
>  	int ver;
>  	void *mem;
> +	static int warn_count;
> +
> +	if (warn_count < 5) {
> +		warn_count++;
> +		printk(KERN_EMERG "smbfs is deprecated and will be removed in"
> +				" December, 2006.  Please migrate to cifs\n");

Surely you mean                             ^^^^ ??? ¿2008?

> +	}
>  
>  	if (!raw_data)
>  		goto out_no_data;
> _
> 
> 
> queued for over 1.5 years waiting for the go-ahead from Steve.
> 
> It looks like it's time?  If so, what should I set the date to?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
