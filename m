Return-Path: <linux-kernel-owner+w=401wt.eu-S1757769AbZFAUhX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757769AbZFAUhX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 16:37:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754128AbZFAUhN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 16:37:13 -0400
Received: from c60.cesmail.net ([216.154.195.49]:60831 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754995AbZFAUhM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 16:37:12 -0400
Subject: Re: EXPORT_SYMBOL_GPL recursive for shim and/or wrappers
From: Pavel Roskin <proski@gnu.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Al Viro <viro@ftp.linux.org.uk>,
       Aaditya.Rai@atheros.com, Prem.Kumar@atheros.com,
       Stephen.Chen@atheros.com, Rahul.Sridhar@atheros.com,
       Allen.Tsai@atheros.com
In-Reply-To: <43e72e890906011241u24b82cc3gc06bf7be4f43075e@mail.gmail.com>
References: <43e72e890906011241u24b82cc3gc06bf7be4f43075e@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 01 Jun 2009 16:37:12 -0400
Message-Id: <1243888632.16765.12.camel@mj>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 (2.26.1-2.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Luis!

On Mon, 2009-06-01 at 12:41 -0700, Luis R. Rodriguez wrote:
> The intention behind EXPORT_SYMBOL_GPL seems clear to me -- prevent
> proprietary drivers from using GPL-only symbols.

I believe the intention was to warn the users that they know so much
about the kernel that they should be considered a derived work of the
kernel and thus should be under GPL themselves.

It doesn't fully exclude the "shims".  I believe it could be
successfully argued in the court that proprietary code using shims is
not a derived work of the kernel if certain care is taken not to expose
the writers of the proprietary part to the internals of the GPL code.

I'm not taking the position of proponents of non-free software.  GPL is
valuable both because of what it permits (e.g. commercial use) and by
what it forbids (e.g. making the code proprietary).  It's better not to
change the rules, as it negatively affects the trust of other people.

Moreover, in this case we could be deceiving ourselves that we can
change the rules, as the definition of the derived work lies outside the
scope of GPL.

IANAL and IMHO

-- 
Regards,
Pavel Roskin
