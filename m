Return-Path: <linux-kernel-owner+w=401wt.eu-S1753900AbYHaOoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900AbYHaOoi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 10:44:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751511AbYHaOoa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 10:44:30 -0400
Received: from qb-out-0506.google.com ([72.14.204.225]:35560 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbYHaOo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 10:44:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=UWfPK6yu91GFFMUXMWwrguT0bb9TcOEK9YlKOCEuCaH/qfX2Cws4vrvGOeWxjiM4Yb
         XoihTitAtA0Yxb/LiKLlsZFTqAatHl+h+BmQqEG9lJjtyY3ccPG4lPgreRyxx6PJbS3S
         q5WYulkPen7R3YOZPS340j7eQWfDcKf0NVgjw=
Date: Sun, 31 Aug 2008 18:44:27 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Oeser <ioe-lkml@rameria.de>, LKML <linux-kernel@vger.kernel.org>,
       Vegard Nossum <vegard.nossum@gmail.com>, bfields@fieldses.org,
       neilb@suse.de
Subject: Re: [PATCH] sunrpc - fixup userspace buffer possible overrun v2
Message-ID: <20080831144427.GC2884@lenovo>
References: <20080831100806.GD7391@lenovo> <200808311609.12275.ioe-lkml@rameria.de> <20080831144129.GB2884@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080831144129.GB2884@lenovo>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cyrill Gorcunov - Sun, Aug 31, 2008 at 06:41:29PM +0400]
| [Ingo Oeser - Sun, Aug 31, 2008 at 04:09:10PM +0200]
| | Hi Cyrill,
| | 
| | On Sunday 31 August 2008, Cyrill Gorcunov wrote:
| | > The conclusion is that proc_do_xprt doesn't check for userside buffer
| | > size indeed so fix. Also set lenp to number of bytes were really written.
| | 
| | Why not use  simple_read_from_buffer() for the read case and
| | keep the -EINVAL for the write case.
| 
| Ah, thanks Ingo - good idea. Btw does libfs.c depends
| on anything?
|
...

yes, it's always compiled in.
 
		- Cyrill -
