Return-Path: <linux-kernel-owner+w=401wt.eu-S1764840AbYD1Cgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764840AbYD1Cgc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 22:36:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761347AbYD1CgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 22:36:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45654 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753767AbYD1CgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 22:36:24 -0400
Date: Sun, 27 Apr 2008 19:36:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: adaplas@gmail.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, hpa@zytor.com
Subject: Re: [PATCH] vt: fix background color on line feed
Message-Id: <20080427193616.9a9cdf85.akpm@linux-foundation.org>
In-Reply-To: <alpine.LNX.1.10.0804270257270.20150@fbirervta.pbzchgretzou.qr>
References: <alpine.LNX.1.10.0804270257270.20150@fbirervta.pbzchgretzou.qr>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Apr 2008 03:12:44 +0200 (CEST) Jan Engelhardt <jengelh@computergmbh.de> wrote:

> commit c5180a555ced08a7e3011c16ef796e47569ae907
> Author: Jan Engelhardt <jengelh@computergmbh.de>
> Date:   Thu Apr 24 22:40:24 2008 +0200
> 
> vt: fix background color on line feed
>     
> A command that causes a line feed while a background color is active,
> such as
>     
> 	perl -e 'print "x" x 60, "\e[44m", "x" x 40, "\e[0m\n"'
> and
> 	perl -e 'print "x" x 40, "\e[44m\n", "x" x 40, "\e[0m\n"'
>     
> causes the line that was started as a result of the line feed to be
> completely filled with the currently active background color instead
> of the default color.

Thanks.

It would be better if the the changelog were to also describe the cause of
the bug, and how the patch fixes it.

