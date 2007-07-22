Return-Path: <linux-kernel-owner+w=401wt.eu-S1756251AbXGVAaM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251AbXGVAaM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 20:30:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753207AbXGVA36
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 20:29:58 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:49288 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432AbXGVA35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 20:29:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=Up2n5Yiop0LMailnORP5KkfgpCBPhbIwJOy09nkl1bwsx2F6MJXJ1bMZpmgPG8Y5s6WFMoeMV1fPhlfPAn2XraH7A9wozMiU7wXJXsOkRUj8g9WLtkZIyfaaXIwo5glgJ1ckeKbGZKOzpyicnuDbOc4RlC+n6Ro2kv8mgFVVL9o=
From: Denis Vlasenko <vda.linux@googlemail.com>
To: Oleg Verych <olecom@flower.upol.cz>
Subject: Re: [PATCH] [9/58] x86_64: Always use builtin memcpy on gcc 4.3
Date: Sun, 22 Jul 2007 01:29:50 +0100
User-Agent: KMail/1.8.2
Cc: Andi Kleen <ak@suse.de>, jh@suse.cz, patches@x86-64.org,
       linux-kernel@vger.kernel.org
References: <200707191154.642492000@suse.de> <20070719095453.5434214E04@wotan.suse.de> <E1ICOBm-0003zf-Ms@flower>
In-Reply-To: <E1ICOBm-0003zf-Ms@flower>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707220129.50223.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 22 July 2007 00:16, Oleg Verych wrote:
> * From: Andi Kleen <ak@suse.de>
> * Date: Thu, 19 Jul 2007 11:54:53 +0200 (CEST)
> >
> > Jan asked to always use the builtin memcpy on gcc 4.3 mainline because
> > it should generate better code than the old macro. Let's try it.
> 
> Unfortunately such info is hard to find. The discuss@x86-64 list is
> empty. So, let me ask how this memcpy relates to recently submitted
> for glibc one [0]?
> 
> [0] <http://permalink.gmane.org/gmane.comp.lib.glibc.alpha/12217>

Am I stupid or the files attached to that post demonstrate than "new"
code isn't much better and sometimes worse (aligned 4096 byte memcpy
went from 558 to 648 for Core 2)?

Beware that text files in test-memcpy.tar.bz2 seem to have
simple_memcpy / builtin_memcpy / memcpy columns swapped
(-old and -new files have them in different order).
--
vda
