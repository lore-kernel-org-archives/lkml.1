Return-Path: <linux-kernel-owner+w=401wt.eu-S1753514AbZAaLpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514AbZAaLpb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 06:45:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751950AbZAaLpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 06:45:23 -0500
Received: from 8bytes.org ([88.198.83.132]:50721 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750984AbZAaLpW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 06:45:22 -0500
Date: Sat, 31 Jan 2009 12:45:20 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Robert Hancock <hancockr@shaw.ca>
Cc: Roger Larsson <roger.larsson@e-gatan.se>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Robert Love <rml@tech9.net>,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: PROBLEM: in_atomic() misuse all over the place
Message-ID: <20090131114520.GA26910@8bytes.org>
References: <200901280010.37633.roger.larsson@e-gatan.se> <497FA2D0.1090605@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <497FA2D0.1090605@shaw.ca>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2009 at 06:12:00PM -0600, Robert Hancock wrote:
> I would think that the code that's using it for this purpose should be 
> changed to do things differently, such as by changing the functions 
> using it to make their caller pass in the proper GFP mask. I don't think 
> it was ever intended to be used to select allocation behavior like this, 
> only for debug warning checks and such.. Getting rid of in_atomic() and 
> creating a in_atomic_warn() that just raises a warning if called 
> atomically, might be the best long-term solution.

I also made the mistake of using in_atomic() wrong in one of my last
patch sets. In my case this was pointed out by the reviewers. Is there
some documentation in the kernel tree how and when in_atomic() is used
right? If not I think its worth writing a little file that explains the
important details about the correct use of in_atomic() :-)

Joerg

