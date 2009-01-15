Return-Path: <linux-kernel-owner+w=401wt.eu-S1762136AbZAOINT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762136AbZAOINT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 03:13:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755535AbZAOINI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 03:13:08 -0500
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:57900 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757295AbZAOINH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 03:13:07 -0500
From: Chandru <chandru@in.ibm.com>
Organization: ibm
To: Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: 2.6.28-rc9 panics with crashkernel=256M while booting
Date: Thu, 15 Jan 2009 13:35:27 +0530
User-Agent: KMail/1.9.10
Cc: Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
References: <200812241325.49404.chandru@in.ibm.com> <1231444992.23462.138.camel@nimitz> <200901091637.24658.chandru@in.ibm.com>
In-Reply-To: <200901091637.24658.chandru@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901151335.27649.chandru@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 January 2009 16:37:24 Chandru wrote:
> On Friday 09 January 2009 01:33:12 Dave Hansen wrote:
> > Now I'm even more confused.  Could you please send a fully changelogged
> > patch that describes the problem, and how this fixes it?  This just
> > seems like an off-by-one error, which isn't what I thought we had before
> > at all.
> > 
> > I'm also horribly confused why PFN_UP is needed here.  Is 'physbase' not
> > page aligned?  reserve_size looks like it *has* to be.  'end_pfn' is
> > always (as far as I have ever seen in the kernel) the pfn of the page
> > after the area we are interested in and we treat it as such in that
> > function.  In the case of an unaligned physbase, that wouldn't be true.
> > 
> > Think of the case where we have a 1-byte reservation.  start_pfn will
> > equal end_pfn and we won't go into that while loop at *all* and won't
> > reserve anything.
> > 
> > Does 'end_pfn' need fixing?
> > 
> 
> Attached is the console log with debug command line parameters enabled and 
> with couple of more debug statements added to the code.  Please take a look at it. 
> 
> thanks,
> Chandru
> 

Hello Dave, From the debug console output, if there is anything you can add here,
pls let me know.

thanks 
