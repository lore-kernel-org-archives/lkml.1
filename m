Return-Path: <linux-kernel-owner+w=401wt.eu-S1758006AbYBDXvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758006AbYBDXvX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 18:51:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755083AbYBDXvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 18:51:16 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37695 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754675AbYBDXvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 18:51:15 -0500
Date: Mon, 4 Feb 2008 15:51:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: CodingStyle: provide good example
Message-Id: <20080204155109.fee3e5e0.akpm@linux-foundation.org>
In-Reply-To: <20080204234343.GA1901@elf.ucw.cz>
References: <20080204234343.GA1901@elf.ucw.cz>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Feb 2008 00:43:43 +0100
Pavel Machek <pavel@ucw.cz> wrote:

> if (!buffer) is actually prefered style, so lets use it in example.
> 
> 								Pavel
> 
> Signed-off-by: Pavel Machek <pavel@suse.cz>
> 
> diff --git a/Documentation/CodingStyle b/Documentation/CodingStyle
> index 6caa146..9bb2d8a 100644
> --- a/Documentation/CodingStyle
> +++ b/Documentation/CodingStyle
> @@ -406,7 +415,7 @@ int fun(int a)
>  	int result = 0;
>  	char *buffer = kmalloc(SIZE);
>  
> -	if (buffer == NULL)
> +	if (!buffer)
>  		return -ENOMEM;
>  
>  	if (condition1) {

I tend to avoid preferring one over the other unless the extra seven
columns is needed to prevent wraparound nasties.
