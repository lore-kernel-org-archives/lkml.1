Return-Path: <linux-kernel-owner+w=401wt.eu-S1760617AbXGTLYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760617AbXGTLYY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 07:24:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755622AbXGTLYQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 07:24:16 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:45241 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754253AbXGTLYP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 07:24:15 -0400
Message-ID: <384930645.25087@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Fri, 20 Jul 2007 19:24:09 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@osdl.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/6] compacting file_ra_state
Message-ID: <20070720112409.GB6300@mail.ustc.edu.cn>
Mail-Followup-To: Peter Zijlstra <peterz@infradead.org>,
	Andrew Morton <akpm@osdl.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <20070720100740.106917381@mail.ustc.edu.cn> <20070720101123.936159499@mail.ustc.edu.cn> <1184927207.20032.168.camel@twins> <1184928539.20032.171.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1184928539.20032.171.camel@twins>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2007 at 12:48:59PM +0200, Peter Zijlstra wrote:
> On Fri, 2007-07-20 at 12:26 +0200, Peter Zijlstra wrote:
> > On Fri, 2007-07-20 at 18:07 +0800, Fengguang Wu wrote:
> > > plain text document attachment (short-rasize.patch)
> > > Use 'unsigned int' instead of 'unsigned long' for the readahead indexes/sizes.
> > > 
> > > This helps reduce memory consumption on 64bit CPU when
> > > a lot of files are opened.
> > > 
> > > Note that the (smaller) 32bit index can support up to 16PB file.
> > > Which should be sufficient large at least for now.
> > 
> > Perhaps merge prev_offset and prev_index into a pgoff_t prev? That
> > should give the same savings on 64bit and be more correct on 32bit.
> 
> s/pgoff_t/loff_t/

Good idea!                                                                                                              
This could solve Andi's concern as well :)                                                                              
                                                                                                                        
I'm coding it up, and sure it'll need some more tests...                                                                

> (and how come lkml was not on the CC list?)

:) 

