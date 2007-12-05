Return-Path: <linux-kernel-owner+w=401wt.eu-S1753888AbXLEPKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888AbXLEPKq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 10:10:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751743AbXLEPKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 10:10:38 -0500
Received: from torres.zugschlus.de ([85.214.68.41]:40364 "EHLO
	torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbXLEPKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 10:10:37 -0500
Date: Wed, 5 Dec 2007 16:10:36 +0100
From: Marc Haber <mh+linux-kernel@zugschlus.de>
To: linux-kernel@vger.kernel.org
Subject: Re: Why does reading from /dev/urandom deplete entropy so much?
Message-ID: <20071205151036.GF24685@torres.zugschlus.de>
References: <20071204114125.GA17310@torres.zugschlus.de> <20071204161811.GB15974@stusta.de> <20071205122912.GC24685@torres.zugschlus.de> <20071205133320.GI7259@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071205133320.GI7259@thunk.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 05, 2007 at 08:33:20AM -0500, Theodore Tso wrote:
> BTW, note that it would be a polite thing for GnuTLS when it is
> encrpyting data, which represents information which might not be
> available to an adversary, and SHA1 hash it (out of paranoia) and feed
> it to /dev/random.  
> 
> This won't give any "credits" to the random entropy counter, but to
> the extent that is information that isn't available to the adversary,
> it adds additional uncertainty to the random pool.

I have filed this as https://savannah.gnu.org/support/index.php?106113

Thanks for suggesting.

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Mannheim, Germany  |  lose things."    Winona Ryder | Fon: *49 621 72739834
Nordisch by Nature |  How to make an American Quilt | Fax: *49 3221 2323190
