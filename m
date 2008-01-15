Return-Path: <linux-kernel-owner+w=401wt.eu-S1755206AbYAOUMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206AbYAOUMR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 15:12:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750841AbYAOUMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 15:12:06 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:29333 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440AbYAOUME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 15:12:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ltcnmkaPicJ2GxbmyJr0V3XE+9C4gSo9wiSYod7wSB9u1LsRZ+sDfIuaS4PUJ5Df0Fvgfd9OkimXoQw2JQyXBODoJrJNdpAxYSPSsOkkFxhvt59/HLfH8NsHc8UYKn7lJTJF2RA8WBvgRiIU4Zlx6koRJSBhNRlYzWy/DT+sPjU=
Message-ID: <4df4ef0c0801151212y64d0a75dsced9f00e7aec431c@mail.gmail.com>
Date: Tue, 15 Jan 2008 23:12:02 +0300
From: "Anton Salikhmetov" <salikhmetov@gmail.com>
To: "Christoph Hellwig" <hch@infradead.org>
Subject: Re: [PATCH 1/2] Massive code cleanup of sys_msync()
Cc: "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Randy Dunlap" <randy.dunlap@oracle.com>, linux-mm@kvack.org,
       jakob@unthought.net, linux-kernel@vger.kernel.org,
       valdis.kletnieks@vt.edu, riel@redhat.com, ksm@42.dk,
       staubach@redhat.com, jesper.juhl@gmail.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       protasnb@gmail.com, miklos@szeredi.hu
In-Reply-To: <20080115193204.GA25866@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <12004129652397-git-send-email-salikhmetov@gmail.com>
	 <12004129734126-git-send-email-salikhmetov@gmail.com>
	 <20080115175705.GA21557@infradead.org>
	 <4df4ef0c0801151102l4d72b6b5j702e21beb1ebe459@mail.gmail.com>
	 <20080115111018.1e27a229.randy.dunlap@oracle.com>
	 <4df4ef0c0801151126p5dfdbc13ga9862c995890c33c@mail.gmail.com>
	 <1200425328.26045.39.camel@twins>
	 <20080115193204.GA25866@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/1/15, Christoph Hellwig <hch@infradead.org>:
> On Tue, Jan 15, 2008 at 08:28:48PM +0100, Peter Zijlstra wrote:
> > Notice that error is already -EINVAL, so a simple goto should suffice.
>
> Yes, for the start of the function you can basically leave it as-is.
>

OK, I will do as you suggest. Thank you for your answers.
