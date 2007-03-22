Return-Path: <linux-kernel-owner+w=401wt.eu-S934126AbXCVRRZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934126AbXCVRRZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 13:17:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934146AbXCVRRZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 13:17:25 -0400
Received: from saeurebad.de ([85.214.36.134]:44229 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934143AbXCVRRX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 13:17:23 -0400
Date: Thu, 22 Mar 2007 18:16:45 +0100
From: Johannes Weiner <hannes-kernel@saeurebad.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] - fix compile warning: `found' might be used uninitialized in this function
Message-ID: <20070322171645.GA5864@localhost>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <04bf01c76c13$5f25ce00$eeeea8c0@aldipc> <20070321235607.GA10998@localhost> <20070322004540.45d8ee87.akpm@linux-foundation.org> <20070322162550.GB5591@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070322162550.GB5591@localhost>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Mar 22, 2007 at 05:26:04PM +0100, Johannes Weiner wrote:
> > The code in there is irksome - it'd be nice to find some way of
> > restructuring it to make it less obscure, and to kill that warning.
> 
> Functionscope or filescope? ;)

Oh well... I think the latter.  I wil clean it up and send the patches
in several steps to seperate opticals from functionals.

=Hannes
