Return-Path: <linux-kernel-owner+w=401wt.eu-S1758212AbYCATmI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758212AbYCATmI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 14:42:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752559AbYCATl5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 14:41:57 -0500
Received: from fk-out-0910.google.com ([209.85.128.191]:56179 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516AbYCATl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 14:41:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=kdD5PcbuN91UBgOyLLUw0cwjLSK+qGj+i2PqqxQ9U88v7ns7Beif8NhGHkQeHr65onWMvidXC4CgPjfXgOLIurtXH/nqAG/JDYbVFKUF8HoXATMStvifuqBdTApOmnNVn/h/57As8WXMUkdxGK9TkEp98CT9wJs+UFhiYWFSPEE=
Message-ID: <74d8fc520803011141q74ec01e4j2185fad3f0073a16@mail.gmail.com>
Date: Sat, 1 Mar 2008 19:41:51 +0000
From: "Gordon Mckeown" <ml_lkml@thefluffyone.net>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Very high IOWait during all disk activity
Cc: "Tomasz Chmielewski" <mangoo@wpkg.org>
In-Reply-To: <74d8fc520803010531h3453ca91m4521f6bd94b1f5ad@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47C82244.60307@wpkg.org>
	 <74d8fc520802290747o2c97992ar7af2b8c295fe2fb2@mail.gmail.com>
	 <47C82C2A.5000301@wpkg.org>
	 <74d8fc520803010531h3453ca91m4521f6bd94b1f5ad@mail.gmail.com>
X-Google-Sender-Auth: 68857a57e1a6c763
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 1, 2008 at 1:31 PM, I wrote:
>  I'll run some more tests with different filesystems to see if this is
>  related to the use of EXT3 specifically.

Much of the system CPU usage does appear to be due to the use of EXT3;
the load with EXT2 is around half that with EXT3.

See graph of results: http://www.ubergeek.org.uk/cpu_usage.png

For Windows, the graph shows total CPU usage as reported by the OS.
For Linux, the combined User+System figure was used.

Regards,

Gordon.
