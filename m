Return-Path: <linux-kernel-owner+w=401wt.eu-S1757840AbZEKR6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757840AbZEKR6S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 13:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755085AbZEKR5z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 13:57:55 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44688 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753184AbZEKR5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 13:57:54 -0400
Date: Mon, 11 May 2009 18:57:27 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-serial@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
       Ferenc Wagner <wferi@niif.hu>, Paul Fulghum <paulkf@microgate.com>
Subject: Re: [PATCH 1/3] Char/serial: refactor ASYNC_ flags
Message-ID: <20090511185727.2a5bd4cb@lxorguk.ukuu.org.uk>
In-Reply-To: <1242049860-29501-1-git-send-email-jirislaby@gmail.com>
References: <1242049860-29501-1-git-send-email-jirislaby@gmail.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 May 2009 15:50:58 +0200
Jiri Slaby <jirislaby@gmail.com> wrote:

> Define ASYNCB_* flags which are bit numbers of the ASYNC_* flags.
> This is useful for {test,set,clear}_bit.
> 
> Also convert each ASYNC_% to be (1 << ASYNCB_%) and define masks
> with the macros, not constants.

Series all applied
