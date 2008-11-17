Return-Path: <linux-kernel-owner+w=401wt.eu-S1756145AbYKQCJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145AbYKQCJT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 21:09:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754654AbYKQCJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 21:09:10 -0500
Received: from yx-out-2122.google.com ([74.125.44.26]:14579 "EHLO
	yx-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754621AbYKQCJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 21:09:09 -0500
MIME-Version: 1.0
Date: Sun, 16 Nov 2008 18:09:07 -0800 (PST)
In-Reply-To: <fa.bpPjMeyj8xB9538KBi6bqExNNEA@ifi.uio.no>
X-IP: 82.113.55.18
References: <fa.mpq0DX5K46IifhpU7MkX+zEPRog@ifi.uio.no> <fa.bpPjMeyj8xB9538KBi6bqExNNEA@ifi.uio.no>
User-Agent: G2/1.0
X-HTTP-UserAgent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.3) 
	Gecko/2008092816 Iceweasel/3.0.3 (Debian-3.0.3-3),gzip(gfe),gzip(gfe)
Message-ID: <dbed9d1b-f761-4621-b328-ee68562a9dd7@z28g2000prd.googlegroups.com>
Subject: Re: Possibility to build more kernels in one shot?
From: cijoml@gmail.com
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Alexey,



Alexey Dobriyan wrote:
> On Tue, Nov 11, 2008 at 08:01:14AM +0100, CIJOML wrote:
> > currently I compile kernel for 12 different machines. I would like to see
> > profile support in kernel, so I could have all my .configs in source and
> > compile them in one shot. and than see in profile directory subdirectories
> > for every config with it's vmlinuz and modules.
>
> Write a script, shouldn't take more than 15 min including testing.
> And use "make O=".

I currently use it, but It is not a good idea (fill make oldconfig 12x
with mostly same answers makes me personally mad)

>
> > I think it would speedup also compilation time because some .o should be than
> > reuse.
>
> Very optimistic hope. Use ccache(1) if you want .o reuse.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
