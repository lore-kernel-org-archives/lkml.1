Return-Path: <linux-kernel-owner+w=401wt.eu-S1759622AbXK0V1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759622AbXK0V1Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 16:27:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754776AbXK0V1P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 16:27:15 -0500
Received: from wr-out-0506.google.com ([64.233.184.234]:44641 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758288AbXK0V1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 16:27:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=w1NsmIsfJxWMPfb59A90MC78Y+woeq6kfLW3Hbr7F2QFG3eHvhhTJs1C6Os4JQW/kAvVsjveo2S4dF8VZJGZHkDcmk4VaBk4OAJDrObh9YUcZayWtn+rxYnfM4Qc5z3aaQdG6nLfKUfBfeJhzjpQtG5OcDgvmlOT9Rgphe4PK4I=
Message-ID: <ed5aea430711271327l1644750dm363f846a23b1cce5@mail.gmail.com>
Date: Tue, 27 Nov 2007 14:27:02 -0700
From: "David Mosberger-Tang" <dmosberger@gmail.com>
To: "Christoph Lameter" <clameter@sgi.com>
Subject: Re: [patch 04/14] ia64: Remove the __SMALL_ADDR_AREA attribute for per cpu access
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-ia64@vger.kernel.org, tony.luck@intel.com
In-Reply-To: <Pine.LNX.4.64.0711271316110.4590@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071127001407.859743255@sgi.com>
	 <20071127001430.083503280@sgi.com>
	 <ed5aea430711262120p45bb5b2t1b16872e74547369@mail.gmail.com>
	 <Pine.LNX.4.64.0711271014550.2310@schroedinger.engr.sgi.com>
	 <ed5aea430711271310i144c005cj25101b7dd6b0d6d9@mail.gmail.com>
	 <Pine.LNX.4.64.0711271316110.4590@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/07, Christoph Lameter <clameter@sgi.com> wrote:
> On Tue, 27 Nov 2007, David Mosberger-Tang wrote:
>
> > Uniformity for the sake of uniformity?  The small data addressing is
> > really elegant and I don't think it should be dropped just for the
> > sake of uniformity.
>
> Uniformity for the sake of code size reduction and easier maintenance.

Code-size reduction?  You must be talking *source* code size
reduction.  Surely the small-data access-method decreases object code
size.

  --david
