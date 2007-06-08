Return-Path: <linux-kernel-owner+w=401wt.eu-S970185AbXFHQMH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970185AbXFHQMH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 12:12:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968169AbXFHQLv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 12:11:51 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:2913 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966932AbXFHQLt (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 12:11:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fBOKwEx8ZnVJ7DiStnk0FIUvrN6kmn8sF4UELXeDEsUyjrx4TvMQiRi5Ug74rJK43+SdTRN3XSOM72i+mo/chONzPj3959tA7Rw0e8M7FEUCHTGA2Vml7BtXad4kKasbflFFisWohuRJbh2C2trFmYolD6Lof/oaX7/GoN9sH94=
Message-ID: <6934efce0706080911y601a8377oad7b1251a95acd64@mail.gmail.com>
Date: Fri, 8 Jun 2007 09:11:47 -0700
From: "Jared Hulbert" <jaredeh@gmail.com>
To: "Christoph Hellwig" <hch@infradead.org>,
       "Jared Hulbert" <jaredeh@gmail.com>, carsteno@de.ibm.com,
       "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       richard.griffiths@windriver.com,
       "Richard Griffiths" <res07ml0@verizon.net>,
       Linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.21] cramfs: add cramfs Linear XIP
In-Reply-To: <20070608160929.GA3366@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070606162305.GA20600@infradead.org>
	 <20070607193844.GB17144@infradead.org> <4669027E.3070406@de.ibm.com>
	 <20070608072609.GA13115@infradead.org> <46690A39.3010402@de.ibm.com>
	 <20070608075717.GA16927@infradead.org> <46690C58.7090304@de.ibm.com>
	 <20070608080401.GA17684@infradead.org>
	 <6934efce0706080905h253d9e3apd4168c5d14d305e5@mail.gmail.com>
	 <20070608160929.GA3366@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, Jun 08, 2007 at 09:05:32AM -0700, Jared Hulbert wrote:
> > Okay so we need some driver that opens/closes this ROM.  This has been
> > done from the dcss block device but that doesn't make sense for most
> > embedded systems.  The MTD allows for this with point(),unpoint().
> > That should work just fine.  It does introduce the MTD as a dependancy
> > which is unnecessary in many systems, but it will work now.
>
> The Linux solution to this problem would be to introduce an option for
> mtd write support.  That way the majority of the code doesn't heave to
> be compiled for the read-only case but you still get a uniform interface.

You mean make an MTD-light interface possible?
