Return-Path: <linux-kernel-owner+w=401wt.eu-S1755738AbYJ3VGM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755738AbYJ3VGM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 17:06:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756948AbYJ3VFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 17:05:50 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:51008 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757587AbYJ3VFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 17:05:48 -0400
Date: Thu, 30 Oct 2008 22:04:34 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org, zippel@linux-m68k.org, akpm@osdl.org,
       linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: Re: [PATCH] Add module_name Kconfig shortcut
Message-ID: <20081030210434.GA1519@uranus.ravnborg.org>
References: <20081028004604.GA17144@x200.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081028004604.GA17144@x200.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2008 at 03:46:04AM +0300, Alexey Dobriyan wrote:
> As correctly noticed in bug 11446 (http://bugzilla.kernel.org/show_bug.cgi?id=11446)
> "To compile this driver as a module, blah-blah" boilerplate is being
> copy-pasted to death with slight variations.
> 
> Add Kconfig token "module_name" to supply module's name. Example:
> 
> 	config FOO
> 		tristate "foo"
> 		module_name foo
> 		---help---
> 		  foo
> 
> Print module's name as following on menuconfigs help screen (press 'h'):
> 
> 	Module name: foo
> 
> 8139too driver converted to show real-life example.
> 
> P.S.: menuconfig only, no checking wrt modular/standalone code et al.

Hi Alexey.

This is a baby step towards moving simple module stuff to Kconfig.
This is the way we want to go when someone cooks up proper support for that.

But we should do it in one go so when someone decide to visit the
8139too driver then they can do a full conversion to the "keep all
module definition in Kconfig" in one step.

Please see a few mails from Roman Zippel outlining his ideas.
I do not recall the details but I do recall that he suggested
to name the source files in Kconfig.

And when we do it we shall at least support it in menuconfig and xconfig.
config and gconfig can come later.

config and gconfig shall at least generate a correct config but may not
show all relavent info.

	Sam

