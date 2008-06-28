Return-Path: <linux-kernel-owner+w=401wt.eu-S1755996AbYF1K0o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996AbYF1K0o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 06:26:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753692AbYF1K0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 06:26:33 -0400
Received: from saeurebad.de ([85.214.36.134]:49016 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751756AbYF1K0c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 06:26:32 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH 02/20] mm: generic show_mem()
References: <20080627115349.743368154@saeurebad.de>
	<20080627120048.059732179@saeurebad.de>
	<20080628042240.GB25492@linux-sh.org>
Date: Sat, 28 Jun 2008 12:25:57 +0200
In-Reply-To: <20080628042240.GB25492@linux-sh.org> (Paul Mundt's message of
	"Sat, 28 Jun 2008 13:22:40 +0900")
Message-ID: <87myl5ama2.fsf@skyscraper.fehenstaub.lan>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Paul Mundt <lethal@linux-sh.org> writes:

> On Fri, Jun 27, 2008 at 01:53:51PM +0200, Johannes Weiner wrote:
>> This implements a platform-independent version of show_mem().
>> 
>> Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
>
> Looking at this again, does having this as a Kconfig option really make
> sense? We have no tristate in-tree users of this that I can see, wouldn't
> this be better off in lib/? It would be preferable not to let the
> HAVE_foo stuff get out of hand if we can avoid it.

I hate the current Kconfig usage, too.  But I figured, if I won't obey
on such decisions by people who maintain it, it won't have a chance to
get in.

So, what do you suggest?  Moving it to lib/ and have one simple #define
if the arch wants to use it or not?

	Hannes
