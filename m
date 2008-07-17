Return-Path: <linux-kernel-owner+w=401wt.eu-S933242AbYGQX2O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933242AbYGQX2O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 19:28:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758061AbYGQX14
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 19:27:56 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:38273 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753619AbYGQX1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 19:27:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=IAz8dg9ts25gATojLM0N+vRCVZ0X/g8baptMLTsyhzGGSUn2/RDhHcaMxJzWCBHZdJ
         VNkA9UevpVGdLzULnZEMJEltQzp9JRDBbFcsK7+V0T0DSGPJ4Rf2uuRsC1cAXK9B4HTF
         2lGLWDtkYaFM5MkD3K26Zl7VCBQrWgyBwupzw=
Message-ID: <19f34abd0807171627t1dd0ac5bx26535b5e19606835@mail.gmail.com>
Date: Fri, 18 Jul 2008 01:27:54 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [bug, netconsole, SLUB] BUG skbuff_head_cache: Poison overwritten
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       "Pekka Enberg" <penberg@cs.helsinki.fi>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <20080717214222.GA29449@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080717214222.GA29449@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2008 at 11:42 PM, Ingo Molnar <mingo@elte.hu> wrote:
> With this config:
>
>   http://redhat.com/~mingo/misc/config-Thu_Jul_17_20_24_45_CEST_2008.bad
>

It doesn't actually work. The config says

    # head: 088fcf34

and I checked out this from the tip tree. But kernel-config still
complains about unknown config options... What went wrong?


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
