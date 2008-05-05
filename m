Return-Path: <linux-kernel-owner+w=401wt.eu-S1759386AbYEEOtQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759386AbYEEOtQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 10:49:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756566AbYEEOs7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 10:48:59 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:11744 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755950AbYEEOs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 10:48:58 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Rene Herman <rene.herman@keyaccess.nl>
Subject: Re: [patch 00/37] PNP resource_table cleanups, v2
Date: Mon, 5 May 2008 08:48:57 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Rene Herman <rene.herman@gmail.com>, Len Brown <lenb@kernel.org>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Adam Belay <ambx1@neo.rr.com>, Li Shaohua <shaohua.li@intel.com>,
       Matthieu Castet <castet.matthieu@free.fr>,
       Thomas Renninger <trenn@suse.de>, Jaroslav Kysela <perex@perex.cz>,
       Andrew Morton <akpm@linux-foundation.org>
References: <20080401151634.730901933@ldl.fc.hp.com> <481DC4E2.7060803@keyaccess.nl> <481DC60A.7090307@keyaccess.nl>
In-Reply-To: <481DC60A.7090307@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805050848.58436.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 04 May 2008 08:19:54 am Rene Herman wrote:
> On 04-05-08 16:14, Rene Herman wrote:
> 
> > In trying to come up with problems I'm only finding a difference in an 
> > added failure mode with respect to the static array if we run out of 
> > memory at a bad time and this is quite unserious.
> 
> I mean, this would be an added mode when just releasing and rbuilding teh 
> list as opposed to teh reusing, it's not a diffeerence with respect to the 
> .index setup.
> 
> So, going to completely slash struct pnp_resource again? :) Would improve 
> things...

It would be nice to get rid of struct pnp_resource, but then I
wouldn't have a place to keep the list pointer.  But I think
it will disappear from most of the interfaces, e.g,. we can
get rid of pnp_get_pnp_resource(), etc.

Bjorn
