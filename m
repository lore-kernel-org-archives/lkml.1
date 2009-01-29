Return-Path: <linux-kernel-owner+w=401wt.eu-S1756763AbZA2Hog@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763AbZA2Hog (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 02:44:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752892AbZA2Ho0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 02:44:26 -0500
Received: from ozlabs.org ([203.10.76.45]:44446 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752779AbZA2Ho0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 02:44:26 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 5/6] module: make modversion_info contain a pointer, not an array.
Date: Thu, 29 Jan 2009 18:14:19 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: linux-kernel@vger.kernel.org, Shawn Bohrer <shawn.bohrer@gmail.com>,
       Jon Masters <jonathan@jonmasters.org>
References: <200901290005.52819.rusty@rustcorp.com.au> <200901290859.40725.rusty@rustcorp.com.au> <20090128144114.4aeaa0ff@infradead.org>
In-Reply-To: <20090128144114.4aeaa0ff@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901291814.19787.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 January 2009 09:11:14 Arjan van de Ven wrote:
> On Thu, 29 Jan 2009 08:59:40 +1030
> Rusty Russell <rusty@rustcorp.com.au> wrote:
> 
> > On Thursday 29 January 2009 01:22:31 Arjan van de Ven wrote:
> > > On Thu, 29 Jan 2009 00:05:52 +1030
> > > Rusty Russell <rusty@rustcorp.com.au> wrote:
> > > 
> > > > 
> > > > With allmodconfig (minus non-building modules) on 32-bit x86:
> > > > Total size of modules before: 60009790 bytes
> > > > Total size of modules after: 55927866 bytes
> > > > 
> > > > Saving 7% of module size for CONFIG_MODVERSIONS=y; and these
> > > > sections are kept resident as well.
> > > > 
> > > 
> > > that reminds me.. can we just simplify MODVERSIONS to be a md5sum
> > > (or sha1 whatver) of the .config file in the VERMAGIC ?
> > > it's a lot more reliable in detecting incompatibilities, and a lot
> > > less space consumed.
> > 
> > Unfortunately people really seem to want the finer granularity that
> > MODVERSIONS (sometimes) provides :(  I've tried killing it off
> > several times, and always failed.
> 
> but we could just stick the result in VERMAGIC right?
> rather than tacking it to every symbol.

Sure, but who would use it?  If you add a driver I don't want my modules to fail.

Confused,
Rusty.
