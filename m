Return-Path: <linux-kernel-owner+w=401wt.eu-S935678AbXHPLYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935678AbXHPLYr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 07:24:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934761AbXHPLXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 07:23:23 -0400
Received: from wr-out-0506.google.com ([64.233.184.239]:1337 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934722AbXHPLXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 07:23:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JDGFkNKNp4Pl2VAxLtICuJIH6DNFAGzJ9vS336wAsMczICGwCczcbIftf/bRT9/HKfGa5Lv2HtRPhYdfpi9gBpgt+Iov76dlQxiROegrRCKzk2upNV+Zxr1ws8Q4BmaBt2tv3rkhr/lqzH9HzDArlB64wmQ6aReEOQ42S6iGJQY=
Message-ID: <9a8748490708160423g4ae218a3v7738f2c6399369e9@mail.gmail.com>
Date: Thu, 16 Aug 2007 13:23:19 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Simon Peter" <simon.peter@gmx.de>
Subject: Re: sysctl_tcp_keepalive_time
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070816125526.9a895d09.simon.peter@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070816125526.9a895d09.simon.peter@gmx.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/08/07, Simon Peter <simon.peter@gmx.de> wrote:
> Hi,
>
> is there any reason why sysctl_tcp_keepalive_time (reflected
> by /proc/sys/net/ipv4/tcp_keepalive_time) is set to 7200 seconds? Is
> this specified somewhere?
>
RFC 1122, section 4.2.3.6 - http://www.faqs.org/rfcs/rfc1122.html

"
         4.2.3.6  TCP Keep-Alives

            Implementors MAY include "keep-alives" in their TCP
            implementations, although this practice is not universally
            accepted.  If keep-alives are included, the application MUST
            be able to turn them on or off for each TCP connection, and
            they MUST default to off.

            Keep-alive packets MUST only be sent when no data or
            acknowledgement packets have been received for the
            connection within an interval.  This interval MUST be
            configurable and MUST default to no less than two hours.
"

This page may also be of interrest to you :
http://www.uic.rsu.ru/doc/inet/tcp_stevens/tcp_keep.htm

Also see "man 7 tcp"


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
