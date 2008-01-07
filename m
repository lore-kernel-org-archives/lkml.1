Return-Path: <linux-kernel-owner+w=401wt.eu-S1758754AbYAGVIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758754AbYAGVIn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 16:08:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757054AbYAGVIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 16:08:35 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:55209 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756983AbYAGVIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 16:08:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=a9pfTBx8sM4WsZCDTwgr/eXgFAZwWm9EL1lF+j8OFg32yopKD/jaA6BIlkmeUrF94npJ+j/XU2dxLJteO6CEUrBHot0aoinfSc3UBrMZtuk1W8no9NlILrcizOu5VQR6tsLoFZmSoePdil87ltnQVA8zQzb9WQl1sWrogF0lkv8=
Date: Mon, 7 Jan 2008 22:10:01 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Ben Fennema <bfennema@falcon.csc.calpoly.edu>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/7] udf: replace loops coded with goto to real loops
Message-ID: <20080107210955.GC22144@joi>
References: <1199582513-7915-1-git-send-email-marcin.slusarz@gmail.com> <1199582513-7915-4-git-send-email-marcin.slusarz@gmail.com> <20080107144821.GK12589@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080107144821.GK12589@duck.suse.cz>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 07, 2008 at 03:48:21PM +0100, Jan Kara wrote:
> On Sun 06-01-08 02:21:50, marcin.slusarz@gmail.com wrote:
> > Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
>   I'm not sure if this improves readability in general. If the code is
> really a loop in nature, then we should code it using do {} while but in
> case we loop back just in case of some error (as seems to be the case in
> udf_bitmap_new_block()), then IMHO goto is more explanative. So at least
> that one case I'd leave as is.
Why do you think it's an error?

Marcin
