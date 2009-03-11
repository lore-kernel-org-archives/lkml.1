Return-Path: <linux-kernel-owner+w=401wt.eu-S1751931AbZCKVtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751931AbZCKVtk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 17:49:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751553AbZCKVtb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 17:49:31 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:32720 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbZCKVta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 17:49:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZzDCutlsCzoX9i/MeuZVLXrXlsXWvqRuuVZ/P7ObD6irfCZrjICN6uNoHJrCL2kvT4
         O9XmxeW8red7JJqnomkzXRimmMzsVMpv8EWUcRQwSIwxylRqwG1gaqidVhXK+4eeqp+K
         yiqUhV2/NhH1+oXx+eddBinm25MaHM2mQ1RC8=
MIME-Version: 1.0
In-Reply-To: <20090311200411.WPUP4619.eastrmmtao102.cox.net@eastrmimpo02.cox.net>
References: <20090311200411.WPUP4619.eastrmmtao102.cox.net@eastrmimpo02.cox.net>
Date: Wed, 11 Mar 2009 21:49:27 +0000
Message-ID: <ef1cd66f0903111449m59c3a29fq5fbd13a682cc2e8b@mail.gmail.com>
Subject: Re: [PATCH] /dev/time for Linux, inspired by Plan 9
From: =?ISO-8859-1?Q?Jochen_Vo=DF?= <jochen.voss@googlemail.com>
To: Christopher Brannon <cmbrannon@cox.net>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christopher,

2009/3/11 Christopher Brannon <cmbrannon@cox.net>:
> +/dev/time provides a file-based interface to the system clock.
> +Using this interface, one can query or set the system clock by reading or
> +writing text strings.  A read of /dev/time yields four decimal integers:
> +seconds since start of epoch, nanoseconds since start of epoch,
> +nanoseconds since boot, and nanoseconds per second.
> [...]
> +Examples
> +--------
> +cat /dev/time
> +# Produces: 1236121128 123612012877063000 495497 300,
> +# at time of writing on a test machine.

The last two numbers in the example seem suspicous to me.  300
nanoseconds per second?

I hope this helps,
Jochen
-- 
http://seehuhn.de/
