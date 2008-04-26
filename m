Return-Path: <linux-kernel-owner+w=401wt.eu-S1757618AbYDZORf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757618AbYDZORf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 10:17:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753493AbYDZORR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 10:17:17 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:37114 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341AbYDZORP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 10:17:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XnmfVe7w2OLac3aeeeQ5jMx/2INIznA1wZeglQJgJiET7COtey+uuHSbOgD5QLhzkHtuizERTo43ITFGX4qsS3UQcNFR+fFK1EXhb2AYTLes2JkkMbBs1N5VYwKXJiYb19HnNdlJwyPNPGNIsyrslzKap8n9OJi2nVzyvRxf/dU=
Message-ID: <19f34abd0804260717le1773aapec49cdb6f68e296f@mail.gmail.com>
Date: Sat, 26 Apr 2008 16:17:15 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] headerdep: a tool for detecting inclusion cycles in header file
Cc: "Sam Ravnborg" <sam@ravnborg.org>, "Adrian Bunk" <bunk@kernel.org>,
       linux-kbuild@vger.kernel.org, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <48133537.7040800@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080426134554.GA20727@damson.getinternet.no>
	 <48133537.7040800@cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/26/08, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> > +# Output dependency graph in GraphViz language.
> > +sub graph {
> >
>
>  Shouldn't there be a command line option for printing out the GraphViz
> files?

Hm. For now, it's a hidden feature that requires editing the script :-)

I didn't want to get into the lands of parsing options since we would
need to handle gcc options and skip arguments to those, etc.

Maybe it's better just to chuck the whole GraphViz thing. It's not
really that useful anyway.

Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
