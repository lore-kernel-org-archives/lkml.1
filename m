Return-Path: <linux-kernel-owner+w=401wt.eu-S1754220AbYCVEhF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220AbYCVEhF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 00:37:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751320AbYCVEgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 00:36:53 -0400
Received: from hs-out-0708.google.com ([64.233.178.250]:3673 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305AbYCVEgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 00:36:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=TwtdLlT9IGQ4rHNtDLpVLotgZk01gdkLTmexvUjabEjffAgoEgluy9eC1lenBcq9efHtnZLKODvr8FmNTfp5f3RZlkbJtPZGacBy0IGtdfmG1ktk9Z4wSgIUvvOCORm+kqbJx9+o9CKd9oxDconitsEUd+k5f2JAnj26PlF7JTY=
Message-ID: <a36005b50803212136s78dc2e4bx5ac715ebc7a6e48a@mail.gmail.com>
Date: Fri, 21 Mar 2008 21:36:51 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [PATCH prototype] [0/8] Predictive bitmaps for ELF executables
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <20080321172644.GG2346@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080318003620.d84efb95.akpm@linux-foundation.org>
	 <20080318095715.27120788.akpm@linux-foundation.org>
	 <20080318172045.GI11966@one.firstfloor.org>
	 <20080318104437.966c10ec.akpm@linux-foundation.org>
	 <20080319083228.GM11966@one.firstfloor.org>
	 <20080319020440.80379d50.akpm@linux-foundation.org>
	 <a36005b50803191545h33d1a443y57d09176f8324186@mail.gmail.com>
	 <20080320090005.GA25734@one.firstfloor.org>
	 <a36005b50803211015l64005f6emb80dbfc21dcfad9f@mail.gmail.com>
	 <20080321172644.GG2346@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2008 at 10:26 AM, Andi Kleen <andi@firstfloor.org> wrote:
>  Concrete suggestions please.

I already spelled it out.  Add a new program header entry, point it to
a bit array large enough to cover all loadable segments.

It is not worth creating problems with this invalid extension just for
old binaries.  Just let those go.  New binaries can automatically get
the array and then there are no extra seeks, the format is well
defined, etc.
