Return-Path: <linux-kernel-owner+w=401wt.eu-S1753370AbYCXTmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370AbYCXTmf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 15:42:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751015AbYCXTmV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 15:42:21 -0400
Received: from gv-out-0910.google.com ([216.239.58.184]:52981 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbYCXTmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 15:42:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VsLUeGUhLFRxRjOT6nXO7Ybey39CkHQfrOj/njagba1lypnUrQI8LIQYTl9cgGGdTY2HA62NfyEY7OErTpqg04R1FzY1WEcZzR2NbVLSqtarHvq+StuOatuyWwq3TLsWYX4j1rcqNR38Qxs1XFi+TqoFk4yDWLThF1+FwWuuE9w=
Message-ID: <a36005b50803241242r2a9b38c5s57d9ac6b084021fa@mail.gmail.com>
Date: Mon, 24 Mar 2008 12:42:14 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Nicholas Miell" <nmiell@comcast.net>
Subject: Re: [PATCH prototype] [0/8] Predictive bitmaps for ELF executables
Cc: "Andi Kleen" <andi@firstfloor.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <1206335761.2438.63.camel@entropy>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080318104437.966c10ec.akpm@linux-foundation.org>
	 <20080320090005.GA25734@one.firstfloor.org>
	 <a36005b50803211015l64005f6emb80dbfc21dcfad9f@mail.gmail.com>
	 <20080321172644.GG2346@one.firstfloor.org>
	 <a36005b50803212136s78dc2e4bx5ac715ebc7a6e48a@mail.gmail.com>
	 <20080322071755.GP2346@one.firstfloor.org>
	 <1206170695.2438.39.camel@entropy>
	 <20080322091001.GA7264@one.firstfloor.org>
	 <a36005b50803232120j63fb08d8p4a6cfdc8df2a3f21@mail.gmail.com>
	 <1206335761.2438.63.camel@entropy>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 23, 2008 at 10:16 PM, Nicholas Miell <nmiell@comcast.net> wrote:
>  The limit is filesystem dependent -- I think ext2/3s is something like
>  4k total for attribute names and values per inode.
>
>  That's more than enough space for the largest executable on my system
>  (emacs at 36788160 bytes) which would have a 1123 byte predictive bitmap
>  (plus space for the name e.g. "system.predictive_bitmap"). The bitmap
>  also could be compressed.

4k attribute means support for about 32768 pages.  That's a total of
134MB.  I think this qualifies as sufficient.  Also, I assume the
attribute limit is just a "because nobody needed more so far" limit
and could in theory be extended.
