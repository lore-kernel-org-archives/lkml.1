Return-Path: <linux-kernel-owner+w=401wt.eu-S1031556AbXD1Qwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031556AbXD1Qwn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 12:52:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031557AbXD1Qwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 12:52:43 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:44687 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031556AbXD1Qwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 12:52:42 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46337BD2.7000701@s5r6.in-berlin.de>
Date: Sat, 28 Apr 2007 18:52:34 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070408 SeaMonkey/1.1.1
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@mindspring.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: random thoughts on DEPRECATED and OBSOLETE
References: <Pine.LNX.4.64.0704280925270.24691@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.64.0704280925270.24691@localhost.localdomain>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert P. J. Day wrote:
> http://fsdev.net/wiki/index.php?title=Maturity_levels
> 
> rday
> 

A few comments:

  - Your argument should include what the benefits of exposing
    DEPRECATED and OBSOLETE as machine-parsable tags are.

  - "...it's not really experimental but nonetheless claims to be. Bad
    craziness all around."
    Won't adding more maturity levels increase craziness?  All of the
    levels except BROKEN are highly subjective.  And such tags can and
    will become outdated.

  - How is the proposed "maturity" keyword to be used?  Will
        maturity EXPERIMENTAL
    replace
        config EXPERIMENTAL
    or
        depends on EXPERIMENTAL
    ?  One of your examples for the usage of the keyword, "maturity
    OBSOLETE && BROKEN", indicates it is the latter.

  - In case it is the latter, didn't you mean by this example "maturity
    OBSOLETE | BROKEN" rather than "maturity OBSOLETE && BROKEN"?

  - I sometimes voiced my opinion that the Kconfig language and files
    should stick to reflect the mere dependencies, while presentation
    should be left to the UIs.  The "maturity" directive is basically
    a variant of "config" or "depends on" with added presentational
    information.  Of course everybody is entitled to have a different
    opinion and ask for more presentational markup in Kconfig.

  - Something /can/ sensibly be DEPRECATED and OBSOLETE at the same
    time.
    (This also means the correct term is not maturity /levels/, but
    maturity attributes or the like.)
-- 
Stefan Richter
-=====-=-=== -=-- ===--
http://arcgraph.de/sr/
