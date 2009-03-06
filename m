Return-Path: <linux-kernel-owner+w=401wt.eu-S1757042AbZCFW56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757042AbZCFW56 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 17:57:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754352AbZCFW5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 17:57:49 -0500
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:45922 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753435AbZCFW5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 17:57:49 -0500
Date: Fri, 6 Mar 2009 22:57:46 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Thanasis <thanasis@asyr.hopto.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: jffs2 and kernel config for SDHC Memory Cards
Message-ID: <20090306225746.GB25593@silver.sucs.org>
References: <49B127AB.6070202@asyr.hopto.org> <49B12B71.7030300@asyr.hopto.org> <20090306182425.GB28349@silver.sucs.org> <49B18679.4030504@asyr.hopto.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49B18679.4030504@asyr.hopto.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 06, 2009 at 10:24:25PM +0200, Thanasis wrote:
> on 03/06/2009 08:24 PM Sitsofe Wheeler wrote the following:
> > On Fri, Mar 06, 2009 at 03:56:01PM +0200, Thanasis wrote:
> >> on 03/06/2009 03:39 PM Thanasis wrote the following:
> >>> I want to use two of these Transcend’s Class 6 SDHC (SD High-Capacity)
> >>> Memory Cards,
> >>> http://www.transcendusa.com/Products/ModDetail.asp?ModNo=147&LangNo=0&Func1No=1&Func2No=13
> >>> as part of the filesystem in a netbook (Acer A110L), will mount /home on
> >>> one, and /tmp and /var on the other.
> >  
> >> Let me rephrase my questions in order to be clearer:
> >> Q1: In order to achieve wear leveling should I format them as jffs2?
> > 
> > This probably won't be very effective as you are already past the

> OK. I believe I should stick to ext2, right?

If you mean compared to jffs2 then probably yes, better to stick with
ext2. If you mean is ext2 the best choice over anything else... well
that's an open question (or so I'm told). You would need to ask a
filesystem expert really but it apparently depends on the workload, the
characteristics of the "disks" and whether you need journaling.

-- 
Sitsofe | http://sucs.org/~sits/
