Return-Path: <linux-kernel-owner+w=401wt.eu-S1759541AbYBET3b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759541AbYBET3b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 14:29:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755474AbYBET3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 14:29:23 -0500
Received: from ti-out-0910.google.com ([209.85.142.191]:52668 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752991AbYBET3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 14:29:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=nHsZ8RDhlQiYUQnEfOFpoUjSAJsKva3WqAObrkKor4D/P/Cg3Trky1WSx1paB6EPXXzQ8XTTPNvOBOIcC794DCbhAOA790sMQByVXprgKLLHyD3yIm59TPwnBbMIaL2uge0IeWCWhNtG8Vt2iymY297y4E+Czg4oCMnA152WoP0=
Date: Tue, 5 Feb 2008 20:21:58 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/6] udf: convert udf_stamp_to_time and
	udf_time_to_stamp to use timestamps
Message-ID: <20080205192153.GB6332@joi>
References: <1202063771-18172-1-git-send-email-marcin.slusarz@gmail.com> <1202063771-18172-5-git-send-email-marcin.slusarz@gmail.com> <20080205155956.GI25464@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080205155956.GI25464@duck.suse.cz>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2008 at 04:59:56PM +0100, Jan Kara wrote:
> On Sun 03-02-08 19:36:09, marcin.slusarz@gmail.com wrote:
> > kernel_timestamp type was almost unused - only callers of udf_stamp_to_time
> > and udf_time_to_stamp used it, so let these functions handle endianness
> > internally and don't clutter code with conversions
>   OK, but please also rename the functions to something like
> udf_disk_stamp_to_time() and udf_time_to_disk_stamp() so that the name
> suggests that it internally handles endianess...
Ok, should I redo this patch or create separate patch on top of it?

Marcin
