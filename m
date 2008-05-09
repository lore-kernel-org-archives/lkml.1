Return-Path: <linux-kernel-owner+w=401wt.eu-S933564AbYEISBu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933564AbYEISBu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 14:01:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754764AbYEISBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 14:01:41 -0400
Received: from ti-out-0910.google.com ([209.85.142.184]:18968 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755957AbYEISBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 14:01:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=lwApvigJ1mu6SvfK/nMaJKz3t6uxEmfjcYOIyH143170g2zJJq3UDIc4NkBjvjZ51O+jViRG10MTunSwu9RKLhiiCl6QMHeblKsBL9G3NXU+zbcNWabJqRXpt8wvrLzFY47dee5ySQjYG2QNePvv1zr/jM70VK3bbBBHDD32RUk=
Message-ID: <e9c3a7c20805091101w6402c17ak5dbee048a1845753@mail.gmail.com>
Date: Fri, 9 May 2008 11:01:35 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Jens Axboe" <jens.axboe@oracle.com>
Subject: Re: [regression?] distcc says: (dcc_pump_sendfile) ERROR: sendfile returned 0? can't cope (bisected)
Cc: "Tom Zanussi" <zanussi@comcast.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20080509112651.GR16217@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1210194811.16427.6.camel@dwillia2-linux.ch.intel.com>
	 <20080507211641.GR16217@kernel.dk>
	 <1210231275.7301.17.camel@charm-linux>
	 <1210306939.7205.9.camel@charm-linux>
	 <20080509112651.GR16217@kernel.dk>
X-Google-Sender-Auth: a5b9aa56c1d911e0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 9, 2008 at 4:26 AM, Jens Axboe <jens.axboe@oracle.com> wrote:
>  Dan, can I talk you into re-trying current git with this patch applied?
>  It's basically the (now) reverted broken bits plus the fix from Tom from
>  this email.
>

distcc appears to be  happy.

Tested-by: Dan Williams <dan.j.williams@intel.com>
