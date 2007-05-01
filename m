Return-Path: <linux-kernel-owner+w=401wt.eu-S1753886AbXEABXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886AbXEABXd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 21:23:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753943AbXEABXc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 21:23:32 -0400
Received: from wr-out-0506.google.com ([64.233.184.228]:16744 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886AbXEABXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 21:23:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=cN3EqfgQhRblxOGHUFLbpXOHAM33rFdq1dDmXs0tRPM42yfyejvGtzdiMYhSioGDHMUj2042O0p/dzFJgO+Inw8AyGYibD93ao13+skOuG2UO9xR+wvD6gWHPMumHfZeo2l0Aqxnoa/GquennzMh1uoDUwYZ9mMA/EpsnKefU1k=
Message-ID: <a36005b50704301823w6a0c4b2fsacb0161d4a9eec73@mail.gmail.com>
Date: Mon, 30 Apr 2007 18:23:29 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Rik van Riel" <riel@redhat.com>
Subject: Re: MADV_FREE functionality
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <46368FAA.3080104@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070430162007.ad46e153.akpm@linux-foundation.org>
	 <46368FAA.3080104@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/30/07, Rik van Riel <riel@redhat.com> wrote:
> Andrew Morton wrote:
> > Because right now, I don't know where we are with respect to these things and
> > I doubt if many of our users know either.  How can Michael write a manpage for
> > this is we don't tell him what it all does?

I think we've been very clear before and Rik's description here puts
it all nicely in one place.  If you're worried about semantics you can
rest assured, it is all sound.  If this is what is holding up the
patch then add it to your collection.  Only if you have technical
objections should you hold it off.  The patch makes sense (and has
been validated by being implemented in the same way on other OSes) and
it is really needed.
