Return-Path: <linux-kernel-owner+w=401wt.eu-S1753893AbYBDLsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893AbYBDLsR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 06:48:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751723AbYBDLsG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 06:48:06 -0500
Received: from mtagate7.de.ibm.com ([195.212.29.156]:16226 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227AbYBDLsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 06:48:04 -0500
Date: Mon, 4 Feb 2008 12:48:01 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Dan Williams" <dan.j.williams@intel.com>
Cc: "Heiko Carstens" <heiko.carstens@de.ibm.com>, herbert@gondor.apana.org.au,
       neilb@suse.de, schwidefsky@de.ibm.com, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: crypto/async_tx/* doesn't build on s390
Message-ID: <20080204124801.02001852@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <e9c3a7c20802030610w17386065h6aca1c20bae080f4@mail.gmail.com>
References: <0C7297FA1D2D244A9C7F6959C0BF1E521D1C6C@azsmsx413.amr.corp.intel.com>
	<20080201123738.24988af7@gondolin.boeblingen.de.ibm.com>
	<e9c3a7c20802011331j2064afe5vc6228fe8363e15de@mail.gmail.com>
	<20080203114056.GB18211@osiris.ibm.com>
	<e9c3a7c20802030610w17386065h6aca1c20bae080f4@mail.gmail.com>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 Feb 2008 07:10:50 -0700,
"Dan Williams" <dan.j.williams@intel.com> wrote:

> On Feb 3, 2008 4:40 AM, Heiko Carstens <heiko.carstens@de.ibm.com> wrote:
> > On Fri, Feb 01, 2008 at 02:31:28PM -0700, Dan Williams wrote:
> [..]
> > The fix works for me. Thanks! However your mailer replaced tabs with spaces
> > and added an extra line break.
> >
> 
> The attached patch is slightly cleaner, and still works.  It marks
> do_async_xor as '__always_inline'.
> 
I can confirm that the patch works for me. Thanks!
