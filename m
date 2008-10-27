Return-Path: <linux-kernel-owner+w=401wt.eu-S1752577AbYJ0Aet@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577AbYJ0Aet (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 20:34:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751321AbYJ0Ael
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 20:34:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:35102 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153AbYJ0Aek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 20:34:40 -0400
Date: Sun, 26 Oct 2008 17:34:58 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Diego M. Vadell" <dvadell@linuxclusters.com.ar>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: PAT and MTRRs
Message-ID: <20081026173458.44c5a036@infradead.org>
In-Reply-To: <49050995.4080508@zytor.com>
References: <200810262246.21807.dvadell@linuxclusters.com.ar>
	<20081026171210.7b3b096a@infradead.org>
	<49050995.4080508@zytor.com>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Oct 2008 17:21:41 -0700
"H. Peter Anvin" <hpa@zytor.com> wrote:

> Arjan van de Ven wrote:
> > 
> > PAT can't make memory cachable that the MTRR's have as uncachable.
> > What PAT *can* do is, within an MTRR, do fine grained mapping...
> > 
> 
> Now, if it wasn't for the braindamage called ACPI and SMM, we could
> have cleared the MTRR settings and just used PAT...
> 

yeah.. one thing we need  to investigate is if we can set the default
"no mtrr coverage" value to cached
(and also.. to check we don't set that to uncached if the bios had it
set to cached..)


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for ape savings, 
visit http://www.lesswatts.org
