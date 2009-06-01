Return-Path: <linux-kernel-owner+w=401wt.eu-S1754359AbZFAVn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754359AbZFAVn2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 17:43:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754128AbZFAVnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 17:43:17 -0400
Received: from kroah.org ([198.145.64.141]:56445 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754007AbZFAVnQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 17:43:16 -0400
Date: Mon, 1 Jun 2009 14:39:37 -0700
From: Greg KH <greg@kroah.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Al Viro <viro@ftp.linux.org.uk>, Pavel Roskin <proski@gnu.org>,
       Aaditya.Rai@atheros.com, Prem.Kumar@atheros.com,
       Stephen.Chen@atheros.com, Rahul.Sridhar@atheros.com,
       Allen.Tsai@atheros.com
Subject: Re: EXPORT_SYMBOL_GPL recursive for shim and/or wrappers
Message-ID: <20090601213937.GA29774@kroah.com>
References: <43e72e890906011241u24b82cc3gc06bf7be4f43075e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43e72e890906011241u24b82cc3gc06bf7be4f43075e@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 01, 2009 at 12:41:58PM -0700, Luis R. Rodriguez wrote:
> Does EXPORT_SYMBOL_GPL imply that modules which make use of these
> symbols must also use EXPORT_SYMBOL_GPL for their own symbols? If so
> then it would be clear of the recursive nature of intent.

I have had a group of lawyers and law-students study this very topic a
lot in the past.  It comes down to "intent".  If you are creating a
"shim" kernel module to merely export the symbols into the "non-gpl"
namespace, the "intent" of such a piece of code is to obviously
circumvent the original "intent" of the GPL-only marking.

This argument was successfully used to cause at least one company to
stop doing this very thing.

Now if you try to explicitly document this somehow, well, I think you
fall into the old "try to explicitly define everything" problem, which
is counterproductive as people try to work around such definitions.  I
say leave it as-is, and let my lawyers have fun if anyone tries to abuse
it :)

thanks,

greg k-h
