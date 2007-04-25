Return-Path: <linux-kernel-owner+w=401wt.eu-S1754617AbXDYX36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617AbXDYX36 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 19:29:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754620AbXDYX36
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 19:29:58 -0400
Received: from ik-out-1112.google.com ([66.249.90.181]:38662 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754617AbXDYX34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 19:29:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=juzIH0fpkbujVmp33NX8i6h9WeSBMcL0eWsNzmjorHrjC79Jjs7AbyC9xu0Hmg6BjWWLYA10bOXjv9HrjB1RJeT9FIqT9vcfBpjlPeY/z1HE9lMCp2Xr6wCEavxcSGjlX0uXSPlDKt+Xz0oEmxrTl+d/v2p4CXGVlwFYOj8qCVw=
Subject: Re: 2.6.21-rc7-mm1: Oops and Gnome desktop freezes
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>
In-Reply-To: <20070425121242.52698643.akpm@linux-foundation.org>
References: <1177512596.4856.17.camel@daplas>
	 <20070425121242.52698643.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 26 Apr 2007 07:29:44 +0800
Message-Id: <1177543785.4668.0.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-25 at 12:12 -0700, Andrew Morton wrote:
> On Wed, 25 Apr 2007 22:49:56 +0800 "Antonino A. Daplas" <adaplas@gmail.com> wrote:
> 
> > The Gnome desktop does not finish launching.  And I get this tracing,
> > all coming from Gnome apps.
> > 
> > Tony
> > 
> > BUG: unable to handle kernel paging request at virtual address c0a74000
> 
> This might have been caused by the now-dropped
> mm-only-i386-for-debugging-make-the-initial-page-table-setup-less-forgiving.patch
> 

Yes, Gnome desktop runs again by dropping this patch.

Tony


