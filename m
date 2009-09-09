Return-Path: <linux-kernel-owner+w=401wt.eu-S1753640AbZIIQJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640AbZIIQJg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 12:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752469AbZIIQJg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 12:09:36 -0400
Received: from fifo99.com ([67.223.236.141]:50391 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751986AbZIIQJf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 12:09:35 -0400
Subject: Re: [PATCH] x86: SGU UV Add volatile to macros that access chipset
 registers
From: Daniel Walker <dwalker@fifo99.com>
To: Jack Steiner <steiner@sgi.com>
Cc: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
In-Reply-To: <20090909154246.GA26716@sgi.com>
References: <20090909154246.GA26716@sgi.com>
Content-Type: text/plain
Date: Wed, 09 Sep 2009 09:10:00 -0700
Message-Id: <1252512600.14793.125.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-09 at 10:42 -0500, Jack Steiner wrote:
> Add "volatile" to the SGI UV read/write macros that are used to access chipset
> memory mapped registers.

There is a considerable document regarding the usage of volatile in the
kernel (Documentation/volatile-considered-harmful.txt). Considering that
document, can you give a more descriptive reason why your using
"volatile" here ?

Daniel


