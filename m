Return-Path: <linux-kernel-owner+w=401wt.eu-S1761831AbXILUSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761831AbXILUSr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 16:18:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754595AbXILUSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 16:18:40 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:9990 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794AbXILUSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 16:18:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=bjtx7/s9W5L78/YLxNF8FciUlgCou68GHLlmjtF54HSxUWaZiPysaKaIKqo/QvD9i3qv13ehE6ILAhQCBhjUaPhpY/r0zfdQ9g88x4j/LtRZst2cvQ78lugm8dJam4RSoFkV5PQmoy2ceGVEOLXBJqMWKAmL53B3lFckyOV0UxI=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Daniel Walker <dwalker@mvista.com>
Subject: Re: [PATCH 1/4] build system: section garbage collection for vmlinux
Date: Wed, 12 Sep 2007 21:18:31 +0100
User-Agent: KMail/1.9.1
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org
References: <200709112105.34301.vda.linux@googlemail.com> <200709112107.53155.vda.linux@googlemail.com> <1189547259.20371.19.camel@imap.mvista.com>
In-Reply-To: <1189547259.20371.19.camel@imap.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709122118.31890.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 September 2007 22:47, Daniel Walker wrote:
> On Tue, 2007-09-11 at 21:07 +0100, Denys Vlasenko wrote:
> > This patch is needed for --gc-sections to work, regardless
> > of which final form that support will have.
> > 
> > This patch renames .text.xxx and .data.xxx sections
> > into .xxx.text and .xxx.data, respectively.
> 
> I think you'll have better luck with this if you focus on a single
> architecture (i386 would be best) .. 

I did exactly that. I focused on x86_64.

Of course, section name fixes cannot be done per-arch, as they
are scattered across entire tree.

Apart from that, it was x86_64 only.

By now, I also have patches for i386 in hand too.
--
vda
