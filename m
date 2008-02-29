Return-Path: <linux-kernel-owner+w=401wt.eu-S1764919AbYB2BM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764919AbYB2BM5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 20:12:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757614AbYB2BKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 20:10:25 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:44412 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751897AbYB2BKX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 20:10:23 -0500
Date: Thu, 28 Feb 2008 17:10:11 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: =?ISO-8859-1?B?IklscG8gSuRydmluZW4i?= <ilpo.jarvinen@helsinki.fi>
Cc: Guillaume Chazarain <guichaz@gmail.com>,
       Giangiacomo Mariotti <giangiacomo_mariotti@yahoo.com>,
       LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>
Subject: Re: WARNING: at net/ipv4/tcp_input.c:2054 tcp_mark_head_lost()
Message-Id: <20080228171011.fc56eace.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0802281018480.32401@kivilampi-30.cs.helsinki.fi>
References: <858077.97160.qm@web39709.mail.mud.yahoo.com>
	<20080223000310.4630daa8.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0802271108290.13029@kivilampi-30.cs.helsinki.fi>
	<3d8471ca0802271056l320a7ee2m5227e114a968d483@mail.gmail.com>
	<Pine.LNX.4.64.0802272120430.1741@kivilampi-30.cs.helsinki.fi>
	<Pine.LNX.4.64.0802281018480.32401@kivilampi-30.cs.helsinki.fi>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Feb 2008 10:22:27 +0200 (EET) "Ilpo Järvinen" <ilpo.jarvinen@helsinki.fi> wrote:

> [PATCH] TCP debug S+L (for 2.6.25-rcs, incompatible with 2.6.24.y)
> 
> ---
>  include/net/tcp.h     |    9 +++-
>  net/ipv4/tcp_input.c  |   18 +++++++-
>  net/ipv4/tcp_ipv4.c   |  127 +++++++++++++++++++++++++++++++++++++++++++++++++
>  net/ipv4/tcp_output.c |   23 +++++++--

I'll put this in -mm, see if we can flush anything out.  Please let me know
if/when it's obsolete, updated, etc.

What is "S+L"?
