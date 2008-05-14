Return-Path: <linux-kernel-owner+w=401wt.eu-S1762959AbYENSGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762959AbYENSGt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 14:06:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755230AbYENSGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 14:06:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59871 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754435AbYENSGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 14:06:39 -0400
Date: Wed, 14 May 2008 11:04:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [1/1] Export __lock_page_killable()
Message-Id: <20080514110407.f8bad229.akpm@linux-foundation.org>
In-Reply-To: <20080514143214.GA12700@2ka.mipt.ru>
References: <20080514141157.GA27047@2ka.mipt.ru>
	<20080514151356.0cb4abfe@core>
	<20080514143214.GA12700@2ka.mipt.ru>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 May 2008 18:32:15 +0400 Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:

> Actually what I want to hear, is that it is needed or not at all...

Yes, I think it's a reasonable thing to export.  We could do it
now as part of a "make the API complete" exercise but more typically
we'd do it when merging code which needs that export.
