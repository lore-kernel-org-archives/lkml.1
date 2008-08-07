Return-Path: <linux-kernel-owner+w=401wt.eu-S1752761AbYHGOOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761AbYHGOOn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 10:14:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751071AbYHGOOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 10:14:35 -0400
Received: from casper.infradead.org ([85.118.1.10]:52057 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbYHGOOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 10:14:34 -0400
Date: Thu, 7 Aug 2008 07:14:27 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: md@google.com (Michael Davidson)
Cc: mingo@redhat.com, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: prevent binaries from making system calls using
 the wrong syscall interface
Message-ID: <20080807071427.38191c79@infradead.org>
In-Reply-To: <20080807003459.37CC629624@localhost>
References: <20080807003459.37CC629624@localhost>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  6 Aug 2008 17:34:59 -0700 (PDT)
md@google.com (Michael Davidson) wrote:

> Prevent binaries from making system calls using other than one
> of the "normal" system call interfaces for that binary type.


since you can have mixed 32 / 64 binaries just fine I don't think your
patch is the right thing to do in general.


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
