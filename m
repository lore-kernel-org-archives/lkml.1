Return-Path: <linux-kernel-owner+w=401wt.eu-S1754720AbZI3XNY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720AbZI3XNY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 19:13:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754627AbZI3XNX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 19:13:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41863 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754585AbZI3XNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 19:13:22 -0400
Date: Wed, 30 Sep 2009 16:13:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] floppy: Add an extra bound check on ioctl arguments
Message-Id: <20090930161316.96b5889e.akpm@linux-foundation.org>
In-Reply-To: <20090930131709.7300dff3@infradead.org>
References: <20090930131709.7300dff3@infradead.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Sep 2009 13:17:09 +0200
Arjan van de Ven <arjan@infradead.org> wrote:

> gcc is not convinced that the floppy.c ioctl has sufficient bound checks,

gad.  You said "floppy" and "ioctl" in the same sentence.  Where angels
fear to tread.

It would be useful if you were to quote the gcc output in the changelog
please.  I assume that you're using some magical new gcc option or
something?

