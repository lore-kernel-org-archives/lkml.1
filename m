Return-Path: <linux-kernel-owner+w=401wt.eu-S1757250AbXIFLAK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757250AbXIFLAK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 07:00:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752433AbXIFK75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 06:59:57 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:27404 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758AbXIFK74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 06:59:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=EQBptFq8sFRS+oEzM25JrW0R+RGLGYxAtXJRZRdKbQbFoCMtTdVPBKjprCXYXgJzjHRd0CAF7ds5KQUmBW7c5zRgnVAGGWQJv0nqZylJWuCnFfSxfTXf+j80qAzRCA5WiFolTYJgAmcuu/JDZulxB4CageP7a2HUJ4hrME0hzjQ=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 1/3] build system: section garbage collection for vmlinux
Date: Thu, 6 Sep 2007 11:59:41 +0100
User-Agent: KMail/1.9.1
Cc: kai@germaschewski.name, linux-kernel@vger.kernel.org
References: <200709051443.21522.vda.linux@googlemail.com> <200709051447.00774.vda.linux@googlemail.com> <20070905200750.GA30812@uranus.ravnborg.org>
In-Reply-To: <20070905200750.GA30812@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709061159.41133.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 September 2007 21:07, Sam Ravnborg wrote:
> On Wed, Sep 05, 2007 at 02:47:00PM +0100, Denys Vlasenko wrote:
> > On Wednesday 05 September 2007 14:43, Denys Vlasenko wrote:
> > > These patches fix section names and add
> > > CONFIG_DISCARD_UNUSED_SECTIONS. It is not enabled
> > > unconditionally because only newest binutils have
> > > ld --gc-sections which is stable enough for kernel use.
> > > IOW: this is an experimental feature for now.
> > 
> > Part 1: fix section names over entire source (all arches).
> > 
> > Patch is big and boring global s/.text.lock/.text_lock/
> > type thing.
> 
> The normal naming scheme seems to be:
> .<usage>.text so in your example it would be: .lock.text
> See the naming og init and exit sections (that was renamed
> during 2.5 to be compatible with -ffunction-sections).

Thanks, will do it that way. I plan to re-submit patches for inclusion
into 2.6.24.
--
vda
