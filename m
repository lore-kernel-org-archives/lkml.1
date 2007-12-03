Return-Path: <linux-kernel-owner+w=401wt.eu-S1752707AbXLCSnE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707AbXLCSnE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 13:43:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751474AbXLCSmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 13:42:55 -0500
Received: from mx2.suse.de ([195.135.220.15]:53651 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751248AbXLCSmy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 13:42:54 -0500
From: Andi Kleen <ak@suse.de>
To: "Jan Beulich" <jbeulich@novell.com>
Subject: Re: x86: optimize page faults like all other achitectures and kill notifier cruft
Date: Mon, 3 Dec 2007 19:38:07 +0100
User-Agent: KMail/1.9.1
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org, hch@lst.de,
       ananth@in.ibm.com, prasanna@in.ibm.com, anil.s.keshavamurthy@intel.com,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
References: <4754132B.76E4.0078.0@novell.com>
In-Reply-To: <4754132B.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712031938.08036.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 December 2007 14:31, Jan Beulich wrote:
> Making the exception notifiers report the right (correct) information (and,
> specific to x86, ensuring they get called in the right place) was one of
> the fundamental things, and just now I see that this is being reverted for
> (in my eyes) no good reason:

FWIW I agree it would be better to put the notifiers back.

-Andi
