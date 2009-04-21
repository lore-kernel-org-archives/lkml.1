Return-Path: <linux-kernel-owner+w=401wt.eu-S1756666AbZDUDAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666AbZDUDAp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 23:00:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753951AbZDUDAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 23:00:13 -0400
Received: from smtp120.mail.mud.yahoo.com ([209.191.84.77]:27014 "HELO
	smtp120.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752151AbZDUDAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 23:00:11 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=fjqxDz5yso0Dgx5JqZy28AvSsOOTHrK+yD05qtuLcyrSUn5VgO51fiBue8Jv51EsNCk/cQIDWUeUiGdhB6vbMjR9AhS891bGYaKtD3FSUTsYm+pIKkt1x0IdJ8y5M5Qg9WwKmUwt7QMzpFsxO81+rAJBNsJeKyafR6kA0pFsZS4=  ;
X-YMail-OSG: 6VHIqcIVM1kPaEkfMVWZltm54kLgKoR0woYHGRalzBIAGYQFZbASCHKx7qovKXiTs3l5Sab7FJYqse_3hWAKFQ.QtQ892n2O21nLWGAdhQpWN9rXzrVf8M4of_IpsRQashmMPvBm.1P4t5MiplZxvDvoLGvYp3HY8wWn3jGByhnFbWKRLB8BL4LbHXWsQbH5gR89Ucw8mk3Wfa.MXkNHIVRRwE4bZqEq_cccjutGUHmJFZrPUnRpnRFrt4x.pEw-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Jared Hulbert <jaredeh@gmail.com>
Subject: Re: [PATCH 0/4] ksm - dynamic page sharing driver for linux v3
Date: Tue, 21 Apr 2009 12:59:58 +1000
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, Izik Eidus <ieidus@redhat.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org,
       avi@redhat.com, aarcange@redhat.com, chrisw@redhat.com,
       mtosatti@redhat.com, hugh@veritas.com, kamezawa.hiroyu@jp.fujitsu.com
References: <1239249521-5013-1-git-send-email-ieidus@redhat.com> <200904170355.26294.nickpiggin@yahoo.com.au> <6934efce0904170008p45cba2c4l3e9ca9f8775c7bde@mail.gmail.com>
In-Reply-To: <6934efce0904170008p45cba2c4l3e9ca9f8775c7bde@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904211259.59752.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 17 April 2009 17:08:07 Jared Hulbert wrote:
> > As everyone knows, my favourite thing is to say nasty things about any
> > new feature that adds complexity to common code. I feel like crying to
> > hear about how many more instances of MS Office we can all run, if only
> > we apply this patch. And the poorly written HPC app just sounds like
> > scrapings from the bottom of justification barrel.
> >
> > I'm sorry, maybe I'm way off with my understanding of how important
> > this is. There isn't too much help in the changelog. A discussion of
> > where the memory savings comes from, and how far does things like
> > sharing of fs image, or ballooning goes and how much extra savings we
> > get from this... with people from other hypervisors involved as well.
> > Have I missed this kind of discussion?
> 
> Nick,
> 
> I don't know about other hypervisors, fs and balloonings, but I have
> tried this out.  It works.  It works on apps I don't consider, "poorly
> written".  I'm very excited about this.  I got >10% saving in a
> roughly off the shelf embedded system.  No user noticeable performance
> impact.

OK well that's what I want to hear. Thanks, that means a lot to me.
