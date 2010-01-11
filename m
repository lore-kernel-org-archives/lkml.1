Return-Path: <linux-kernel-owner+w=401wt.eu-S1752856Ab0AKWmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856Ab0AKWmq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 17:42:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752543Ab0AKWmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 17:42:46 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54740 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750757Ab0AKWmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 17:42:45 -0500
Date: Mon, 11 Jan 2010 14:42:04 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Stefani Seibold <stefani@seibold.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, apw@canonical.com,
       jschopp@austin.ibm.com, davej@redhat.com
Subject: Re: [PATCH] checkpatch.pl: add union and struct to the exceptions
 list
Message-Id: <20100111144204.f52568d6.akpm@linux-foundation.org>
In-Reply-To: <1262796360.1011.9.camel@wall-e>
References: <1262796360.1011.9.camel@wall-e>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Jan 2010 17:46:00 +0100
Stefani Seibold <stefani@seibold.net> wrote:

> This patch add the struct and union keywords to the exceptions list of
> the checkpatch.pl script, to prevent error message "Macros with multiple
> statements should be enclosed in a do - while loop". Otherwise it is not
> possible to build a struct or union with a macro. 
> 
> Signed-off-by: Stefani Seibold <stefani@seibold.net>
> ---
>  checkpatch.pl |    2 ++
>  1 file changed, 2 insertions(+)
> 
> --- linux-2.6.33-rc2.orig/scripts/checkpatch.pl	2009-12-03 04:51:21.000000000 +0100
> +++ linux-2.6.33-rc2.new/scripts/checkpatch.pl	2010-01-06 17:35:29.747634447 +0100
> @@ -2348,6 +2348,8 @@ sub process {
>  				DECLARE_PER_CPU|
>  				DEFINE_PER_CPU|
>  				__typeof__\(|
> +				union|
> +				struct|
>  				\.$Ident\s*=\s*|
>  				^\"|\"$
>  			}x;

hm.  Perhaps it would help if you could provide a snippet of code which
triggers the incorrect warning?

