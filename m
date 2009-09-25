Return-Path: <linux-kernel-owner+w=401wt.eu-S1752198AbZIYGmJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198AbZIYGmJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 02:42:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751961AbZIYGmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 02:42:07 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:48271 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbZIYGmG convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com;4:1>);
	Fri, 25 Sep 2009 02:42:06 -0400
Message-Id: <4ABC82600200007800016C5C@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Fri, 25 Sep 2009 07:42:08 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Paul Mundt" <lethal@linux-sh.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Rusty Russell" <rusty@rustcorp.com.au>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] module: Fix up CONFIG_KALLSYMS=n build.
References: <20090925034557.GA12810@linux-sh.org>
In-Reply-To: <20090925034557.GA12810@linux-sh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Paul Mundt <lethal@linux-sh.org> 25.09.09 05:45 >>>
>There are three different issues:
>
>    - layout_symtab() takes a const Elf_Ehdr
>
>    - layout_symtab() needs to return a value
>
>    - symoffs/stroffs/strmap are referenced by the load_module() code
>      despite being ifdefed out, which seems unnecessary given the noop
>      behaviour of layout_symtab()/add_kallsyms() in the case of
>      CONFIG_KALLSYMS=n.
>
>Signed-off-by: Paul Mundt <lethal@linux-sh.org>

Oh, sorry for not having checked that. Thanks, and

Acked-by: Jan Beulich <jbeulich@novell.com>

