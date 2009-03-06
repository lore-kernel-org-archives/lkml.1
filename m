Return-Path: <linux-kernel-owner+w=401wt.eu-S1756082AbZCFXxB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756082AbZCFXxB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 18:53:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755746AbZCFXww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 18:52:52 -0500
Received: from rv-out-0506.google.com ([209.85.198.224]:43567 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755673AbZCFXwv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 18:52:51 -0500
MIME-Version: 1.0
In-Reply-To: <20090306154852.8354fe52.akpm@linux-foundation.org>
References: <E1LfeFk-0002mD-OE@zelda.netsplit.com>
	 <20090306154852.8354fe52.akpm@linux-foundation.org>
Date: Sat, 7 Mar 2009 00:52:50 +0100
Message-ID: <ac3eb2510903061552x696eb33ctf587449318e2615a@mail.gmail.com>
Subject: Re: [PATCH] floppy: Provide a PNP device table in the module.
From: Kay Sievers <kay.sievers@vrfy.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Scott James Remnant <scott@canonical.com>, linux-kernel@vger.kernel.org,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Philippe De Muyter <phdm@macqel.be>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 7, 2009 at 00:48, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Fri, 6 Mar 2009 17:50:47 +0000
> Scott James Remnant <scott@canonical.com> wrote:
>
>> The missing device table means that the floppy module is not
>> auto-loaded, even when the appropriate PNP device (0700) is found.
>
> Is this a regression?  Did 2.6.28 autoload OK?

No, it was never autoloaded by a kernel supplied alias. We ship
special modprobe rules which define the alias, and this is part of an
ongoing effort to move that information where it belongs, into the
module itself.

Thanks,
Kay
