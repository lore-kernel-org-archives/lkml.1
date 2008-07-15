Return-Path: <linux-kernel-owner+w=401wt.eu-S1756124AbYGOWvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124AbYGOWvT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 18:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752516AbYGOWvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 18:51:09 -0400
Received: from mail.lang.hm ([64.81.33.126]:42227 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753415AbYGOWvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 18:51:08 -0400
Date: Tue, 15 Jul 2008 15:50:09 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: David Woodhouse <dwmw2@infradead.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Marcel Holtmann <marcel@holtmann.org>, Frans Pop <elendil@planet.nl>,
       jeff@garzik.org, arjan@infradead.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from	in-kernel,
 use it in more drivers.
In-Reply-To: <1216160785.26991.51.camel@shinybook.infradead.org>
Message-ID: <alpine.DEB.1.10.0807151549400.16109@asgard.lang.hm>
References: <1216077806.27455.85.camel@shinybook.infradead.org>  <20080714164119.99c33d5b.akpm@linux-foundation.org>  <20080714165956.7fe2d4ee@infradead.org> <487C0365.5030203@garzik.org>  <487C0365.5030203@garzik.org>  <alpine.LFD.1.10.0807141911270.3017@woody.linux-foundation.org>
  <200807151757.10626.elendil@planet.nl>  <1216149637.27242.65.camel@violet.holtmann.net>  <alpine.LFD.1.10.0807151223290.3351@woody.linux-foundation.org>  <1216150616.27455.377.camel@shinybook.infradead.org>  <alpine.LFD.1.10.0807151244320.3351@woody.linux-foundation.org>
  <1216151640.27242.90.camel@violet.holtmann.net>  <alpine.LFD.1.10.0807151301130.2867@woody.linux-foundation.org>  <alpine.DEB.1.10.0807151426021.16109@asgard.lang.hm>  <alpine.LFD.1.10.0807151436400.2867@woody.linux-foundation.org> 
 <alpine.DEB.1.10.0807151503310.16109@asgard.lang.hm> <1216160785.26991.51.camel@shinybook.infradead.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jul 2008, David Woodhouse wrote:

> On Tue, 2008-07-15 at 15:24 -0700, david@lang.hm wrote:
>>
>>> Why is it suddenly so important that a kernel be 'zero impact' for that
>>> module case, when it's never been zero impact for that case before? You
>>> had to rewrite the initrd to begin with, but now you're not willing to do
>>> it again, just because you have to rewrite it slightly _differently_?
>>
>> becouse the tools that wrote the initrd already put the modules in. I
>> don't maintain those tools, they came with the distro. we're just asking
>> to not require those tools to be updated immediatly.
>
> The tools that write the initrd already put the firmware in too.

not always, as Jeff showed.

David Lang
