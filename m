Return-Path: <linux-kernel-owner+w=401wt.eu-S1755227AbZFCKZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755227AbZFCKZW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 06:25:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753316AbZFCKZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 06:25:12 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:46062 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753185AbZFCKZK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 06:25:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=b1xfAZDT9jdePrdBjS2rdcyzjGc1aHcc9Dkzpe0yc+ezAtAbGf2FlV8ZBnx5is/QuZ
         clgxhi0C7l3u1aDBwV2GdA7HIJ0Cqs/kP72dzHgT/f1NMVzjzVLDgZEpOQc0qADkVKCU
         K4q5edvkUcznkjJmwBZhjCx4enQ8GCu73Fwao=
MIME-Version: 1.0
In-Reply-To: <4A202FF3.2090600@pentek.com>
References: <4A202FF3.2090600@pentek.com>
Date: Wed, 3 Jun 2009 12:25:12 +0200
Message-ID: <c384c5ea0906030325q437a299dkf65d47f7f9956f8a@mail.gmail.com>
Subject: Re: O_DIRECT splice from PCI-resident buffer to filesystem
From: Leon Woestenberg <leon.woestenberg@gmail.com>
To: Steve Rottinger <steve@pentek.com>
Cc: linux-kernel@vger.kernel.org, leon@sidebranch.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steve,

On Fri, May 29, 2009 at 8:56 PM, Steve Rottinger <steve@pentek.com> wrote:
> After some work, and kernel hacking, and thanks to Jens'
> O_DIRECT/blockio splicing
> patch,  I have been successful in using splice to transfer data directly
> from a buffer
> resident on a PCI device to a raw disk partition, with zero copies. Great!
>

As we have no in-kernel character devices with splice_read/write
capability (other than /dev/null and maybe zero) *AFAIK*,
I would like to adapt my driver in staging/ to support splice_read()/write().

The difference is that my PCIe driver (altpciechdma.c) performs DMA
into a scattered set of pages. These pages are then
splice()d over.

Could you share the splice part of your driver for this purpose, so
that I can add splice_read() with less effort?

Regards,
-- 
Leon
