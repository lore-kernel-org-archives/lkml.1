Return-Path: <linux-kernel-owner+w=401wt.eu-S1750954AbXCLSOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750954AbXCLSOU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 14:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751073AbXCLSOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 14:14:20 -0400
Received: from mu-out-0910.google.com ([209.85.134.184]:7742 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbXCLSOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 14:14:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=iV5QM5xqjpoJhLja1O9NZEOOZAT0JLC10oLz0k27zIXadFkpHTLkUL7r5h8WDj0B0IBS8bObKuVLa5JIilMbPz4pkKV5o01B4pAS0BO3BMfglZtrh/nR0f+TqMy6x0HlmHmbTY275UY4QMijCJVJWQ5Hlt28tnQzbSXuOe5cHKY=
Message-ID: <f44c5fdf0703121114g39cb3f2ew543b487ba897fe1f@mail.gmail.com>
Date: Mon, 12 Mar 2007 19:14:17 +0100
From: "Radoslaw Szkodzinski" <astralstorm@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>,
       "Theodore T'so" <tytso@mit.edu>
Subject: Re: 2.6.21-rc3-mm1
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070307201839.6f45735b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070307201839.6f45735b.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/8/07, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> - Re-added the ext4 development tree to the -mm lineup.  It has stuff in
>   it.
>

And broken stuff too :-)
The nanoseconds patch is broken on x86_64 - makes mtimes from the future:
e.g. year 2431. I suspect an endianness issue.
x86 works fine according to my sources.

The files themselves have correct mtimes, as booting previous kernel
or one w/o the nanoseconds patch works fine.
