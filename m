Return-Path: <linux-kernel-owner+w=401wt.eu-S1758769AbZBZVu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758769AbZBZVu7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 16:50:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759402AbZBZVug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 16:50:36 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39005 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756029AbZBZVuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 16:50:35 -0500
Date: Thu, 26 Feb 2009 13:49:24 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Claudio Scordino <claudio@evidence.eu.com>
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, hinko.kocevar@cetrtapot.si,
       janez.cufer@cetrtapot.si, starvik@axis.com, jesper.nilsson@axis.com,
       apw@canonical.com, linux-kernel@vger.kernel.org, dev-etrax@axis.com
Subject: Re: [PATCH]  Cleanup patch for RS485 on Cris architecture
Message-Id: <20090226134924.e4d88605.akpm@linux-foundation.org>
In-Reply-To: <49A51878.7020206@evidence.eu.com>
References: <49A51878.7020206@evidence.eu.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Feb 2009 11:07:52 +0100
Claudio Scordino <claudio@evidence.eu.com> wrote:

> Dear Alan, dear Andrew,
> 
>      around one month ago I submitted a cleanup patch to use the new 
> general RS485 Linux data structure (introduced by Alan with commit 
> number c26c56c0f40e200e61d1390629c806f6adaffbcc) in the Cris 
> architecture too (currently, Cris still uses the old private data 
> structure instead of the new one).
> 
> The code compiled, but I couldn't test it at that time.
> 
> Now, the code has been tested by Hinko Kocevar and Janez Cufer 
> (CC:-ed) from the AXIS group, who also fixed a bug.
> 
> Therefore, can you please commit the patch in attachment ?
> 
> Many thanks,
> 
>              Claudio Scordino
> 
> 
> [0001-RS485-support-on-Cris-rewritten-in-order-to-use-new.patch  text/x-diff (9.9KB)]
> >From 9d4397feff9773820e158693aa73621c0c20f017 Mon Sep 17 00:00:00 2001
> From: Claudio Scordino <claudio@evidence.eu.com>
> Date: Tue, 24 Feb 2009 18:00:44 +0100
> Subject: [PATCH 1/1] RS485 support on Cris rewritten in order to use new serial_rs485 data structure
> 
> 
> Signed-off-by: Claudio Scordino <claudio@evidence.eu.com>
> Tested-by: Hinko Kocevar <hinko.kocevar@cetrtapot.si>
> Tested-by: Janez Cufer <janez.cufer@cetrtapot.si>

The patch had no changelog - please always provide one.

I scraped some text from your covering comment and made this:

    Use the new general RS485 Linux data structure (introduced by
    Alan with commit number c26c56c0f40e200e61d1390629c806f6adaffbcc)
    in the Cris architecture too (currently, Cris still uses the old
    private data structure instead of the new one).

for a changelog.  Feel free to send better text if that is inappropriate
or incomplete.
