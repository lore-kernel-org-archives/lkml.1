Return-Path: <linux-kernel-owner+w=401wt.eu-S1759032AbYC0RsH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759032AbYC0RsH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 13:48:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754804AbYC0Rrz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 13:47:55 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:9921 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754717AbYC0Rry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 13:47:54 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Rene Herman <rene.herman@keyaccess.nl>
Subject: Re: [patch 00/37] PNP resource_table cleanups
Date: Thu, 27 Mar 2008 11:50:28 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Adam Belay <ambx1@neo.rr.com>,
       Li Shaohua <shaohua.li@intel.com>,
       Matthieu Castet <castet.matthieu@free.fr>,
       Thomas Renninger <trenn@suse.de>, Jaroslav Kysela <perex@perex.cz>,
       Andrew Morton <akpm@linux-foundation.org>
References: <20080326171058.099442579@ldl.fc.hp.com> <200803261713.03248.bjorn.helgaas@hp.com> <47EAEA98.7010500@keyaccess.nl>
In-Reply-To: <47EAEA98.7010500@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803271150.30512.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 March 2008 06:30:16 pm Rene Herman wrote:
> On 27-03-08 00:13, Bjorn Helgaas wrote:
> 
> > Oops, sorry, I forgot to export pnp_get_resource().  I'll post an updated
> > patch as a response to the original.  Is that easy for you to handle,
> > Len?  If not, let me know what you'd prefer.
> 
> Works for me at least. Only had time for a quick test. After applying these, 
> my snd-cs4236 driver ISAPnP soundcard is no longer found.

Are any ISAPNP devices at all found?  It's possible I broke ISAPNP
completely, because I don't have anything to test it with.  If you
have a chance, maybe you could turn on CONFIG_PNP_DEBUG and send me
a dmesg log.

Bjorn
