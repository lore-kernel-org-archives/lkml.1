Return-Path: <linux-kernel-owner+w=401wt.eu-S1760073AbXJYUYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760073AbXJYUYi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 16:24:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751710AbXJYUY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 16:24:28 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57766 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbXJYUY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 16:24:27 -0400
Date: Thu, 25 Oct 2007 13:20:51 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Michael Lothian <mike@fireburn.co.uk>, linux-kernel@vger.kernel.org
Subject: Re: Possibility of adding -march=native to x86
Message-ID: <20071025132051.20cfd376@laptopd505.fenrus.org>
In-Reply-To: <20071025202031.GU30533@stusta.de>
References: <0EC33A59AA72084CA28B83816B40929F02682BB3@REEDXCLSXM01V03.rbsres01.net>
	<fc94aae90710251133j4bada173h6298242ece586b61@mail.gmail.com>
	<20071025185022.GP30533@stusta.de>
	<fc94aae90710251209n74e2cffbj2e3cdd321f36da0d@mail.gmail.com>
	<20071025191723.GQ30533@stusta.de>
	<fc94aae90710251232m117421e7ref3e5a6270ff25d2@mail.gmail.com>
	<20071025195020.GS30533@stusta.de>
	<fc94aae90710251312w2eba46e8h5d4f8715ad0e91b6@mail.gmail.com>
	<20071025202031.GU30533@stusta.de>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Oct 2007 22:20:31 +0200
Adrian Bunk <bunk@kernel.org> wrote:

> On Thu, Oct 25, 2007 at 09:12:45PM +0100, Michael Lothian wrote:
> > > The MPENTIUM4 option does not only set -march=pentium4, it also
> > > enables several other options in arch/i386/Kconfig.cpu resulting
> > > in better performance.
> > 
> > How about an autodetect to set the right options here too using
> > cpuid?
> > 
> > With a warning of course that the code produced will be specifically
> > for the native cpu that it's compiled on.
> 
> If you don't know or can figure out yourself the CPU you have, you'd 
> better not compile your own kernel...
> 
... or if there is more than just one CPU type, you pick generic.


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
