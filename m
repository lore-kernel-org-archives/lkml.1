Return-Path: <linux-kernel-owner+w=401wt.eu-S1754351AbYJaJWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351AbYJaJWR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 05:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753260AbYJaJWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 05:22:00 -0400
Received: from lazybastard.de ([212.112.238.170]:52393 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754088AbYJaJWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 05:22:00 -0400
Date: Fri, 31 Oct 2008 10:20:55 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
       Pavel Machek <pavel@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] B+Tree library
Message-ID: <20081031092054.GC18182@logfs.org>
References: <20081026124643.GA1328@logfs.org> <20081030174300.GA1773@ucw.cz> <20081030175844.GC7157@logfs.org> <200810310738.46326.borntraeger@de.ibm.com> <20081031073507.GB18182@logfs.org> <Pine.LNX.4.64.0810311016160.22521@anakin>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0810311016160.22521@anakin>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 October 2008 10:16:27 +0100, Geert Uytterhoeven wrote:
> 
> Where's the MIN/MAX? ;-)

#define MAX(a, b) ((a) > (b) ? (a) : (b))
#define NODESIZE MAX(L1_CACHE_BYTES, 128)

struct btree_geo btree_geo32 = {
        .keylen = 1,
        .no_pairs = NODESIZE / sizeof(long) / 2,
};

/me senses a bikeshed discussion.

Jörn

-- 
You cannot suppose that Moliere ever troubled himself to be original in the
matter of ideas. You cannot suppose that the stories he tells in his plays
have never been told before. They were culled, as you very well know.
-- Andre-Louis Moreau in Scarabouche
