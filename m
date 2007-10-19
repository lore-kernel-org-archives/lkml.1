Return-Path: <linux-kernel-owner+w=401wt.eu-S1764181AbXJSA1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764181AbXJSA1b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 20:27:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756492AbXJSA1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 20:27:24 -0400
Received: from gw.goop.org ([64.81.55.164]:51207 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752773AbXJSA1X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 20:27:23 -0400
Message-ID: <4717F9E6.6080705@goop.org>
Date: Thu, 18 Oct 2007 17:27:18 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Bernhard Walle <bwalle@suse.de>, linux-kernel@vger.kernel.org,
       kexec@lists.infradead.org, vgoyal@in.ibm.com
Subject: Re: [patch 1/3] Add BSS to resource tree
References: <20071018111535.356215664@strauss.suse.de> <20071018111535.883533731@strauss.suse.de> <20071018142642.5b3f6ba4.akpm@linux-foundation.org> <20071018214836.GA3459@bingen.suse.de> <20071018215827.GB23708@uranus.ravnborg.org> <20071018220048.GB3459@bingen.suse.de> <20071018221813.GA23801@uranus.ravnborg.org>
In-Reply-To: <20071018221813.GA23801@uranus.ravnborg.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> And I recall that extern char sym[] is considered correct by binutils 
> people - but I'm not 100% sure and google did not give me an appropriate hit.

Yes, I generally prefer char[] - but only because gcc irritatingly
rejects void []...

    J
