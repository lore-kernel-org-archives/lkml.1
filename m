Return-Path: <linux-kernel-owner+w=401wt.eu-S1756764AbZAFXtr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764AbZAFXtr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 18:49:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752693AbZAFXth
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 18:49:37 -0500
Received: from rv-out-0506.google.com ([209.85.198.232]:30777 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993AbZAFXtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 18:49:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ah0a/og+I/uc8O2nHAdmNdC9eiK+FeF8pIAMii7au/YIomrS2TQsGPtLIzgzhTsEOC
         5DzSu2qov5+aDpORY80PZAH1awZJ2ymp9YVvg9ikK0ay+zsFkkn0+1+eleff1uYul5ZM
         enEL+F3fseQHul0taIPupsXYCeiQD/iazb2B0=
Subject: Re: 2.6.29 -mm merge plans
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Diego E. 'Flameeyes' Petten?" <flameeyes@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Warren Turkal <wt@penguintechs.org>,
       Roman Zippel <zippel@linux-m68k.org>
In-Reply-To: <20090106233153.GA16469@infradead.org>
References: <20090105004300.19ed52d1.akpm@linux-foundation.org>
	 <20090106225744.GA10553@infradead.org>
	 <20090106151747.c640dfd4.akpm@linux-foundation.org>
	 <20090106231958.GA30271@infradead.org> <1231284433.5158.2.camel@localhost>
	 <20090106233153.GA16469@infradead.org>
Content-Type: text/plain
Date: Tue, 06 Jan 2009 15:49:33 -0800
Message-Id: <1231285773.1529.4.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-06 at 18:31 -0500, Christoph Hellwig wrote:
> Yes, the version you attached looks much better, and correct.
> 
> Just some minor comments:
> 
> > +++ b/fs/hfsplus/export.c
> > @@ -0,0 +1,118 @@
> > +/*
> > + *  linux/fs/hfsplus/export.c
> > + *
> 
> Please don't put filenames in top of file comments.  They don't serve
> any purpose and easily get out of date.
> 
> > +	if ( be16_to_cpu(entry.type) != HFSPLUS_FOLDER_THREAD) {
> 
> no space after the opening brace, please/

One other nit, byteswap the constant so it can be done at compile-time:

	if (entry.type != cpu_to_be16(HFSPLUS_FOLDER_THREAD)) {

Harvey

