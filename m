Return-Path: <linux-kernel-owner+w=401wt.eu-S1755365AbYKJR63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365AbYKJR63 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 12:58:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752900AbYKJR6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 12:58:21 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:57100 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836AbYKJR6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 12:58:20 -0500
Date: Mon, 10 Nov 2008 09:58:16 -0800
From: Gary Hade <garyhade@us.ibm.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: "GARCIA DE SORIA LUCENA, JUAN JESUS" <juanj.g_soria@grupobbva.com>,
       linux-kernel@vger.kernel.org, garyhade@us.ibm.com
Subject: Re: Regression: Boot hang sizing transparent PCI-to-PCI bridge
	since after 2.6.25-r7.
Message-ID: <20081110175815.GA7650@us.ibm.com>
References: <D913A682D10DBA4097B5D068D281B09B0266F65B@S1128EXE.bbva.igrupobbva> <49180973.6080808@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49180973.6080808@gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2008 at 11:14:11AM +0100, Jiri Slaby wrote:
> On 11/10/2008 10:12 AM, GARCIA DE SORIA LUCENA, JUAN JESUS wrote:
> > Hello.
> > 
> > Time ago I bisected a commit that was making my OKI Anima 3300 laptop
> > hang during boot.
> 
> Doesn't pci=norom help in your case? There was a patch which tried to resolve
> this issue in a different manner, but it was reverted too. This boot parameter
> was introduced as a replacement IIRC.

As the unfortunate author of both of the reverted patches and author
of the pci=norom patch I can confirm that Jiri is correct.  The issues
that the patches addressed (with some unintended side effects caused
by the reverted attempts) were PCI resource allocation failures observed
during PCI hotplug.  We were not seeing or trying to address boot-time
PCI resource allocation failures or hangs.

Gary

-- 
Gary Hade
System x Enablement
IBM Linux Technology Center
503-578-4503  IBM T/L: 775-4503
garyhade@us.ibm.com
http://www.ibm.com/linux/ltc

