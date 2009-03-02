Return-Path: <linux-kernel-owner+w=401wt.eu-S1758210AbZCBR2o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758210AbZCBR2o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 12:28:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754727AbZCBR2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 12:28:35 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:34802 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754004AbZCBR2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 12:28:35 -0500
Subject: Re: [PATCH] crc32: remove useless __pure modifier from functions
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Thiago Galesi <thiagogalesi@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <82ecf08e0903020750q3670de6u4162e4f01c847003@mail.gmail.com>
References: <1236007103.18284.83.camel@penberg-laptop>
	 <82ecf08e0903020750q3670de6u4162e4f01c847003@mail.gmail.com>
Date: Mon, 02 Mar 2009 19:28:31 +0200
Message-Id: <1236014911.18284.89.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-02 at 12:50 -0300, Thiago Galesi wrote:
> Actually, the effects of most keywords (like const, etc) affect things
> outside of the module (the callers)
> 
> http://gcc.gnu.org/onlinedocs/gcc-4.2.0/gcc/Function-Attributes.html
> has a good explanation.
> 
> Briefly, a _pure function only depends on its parameters and the only
> return is via the function return, so the compiler can optimize some
> of its calls away.

Hmm. They're not marked as pure in the header files. Does GCC look it up
from the object file or something for this...?

			Pekka

