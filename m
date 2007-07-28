Return-Path: <linux-kernel-owner+w=401wt.eu-S965509AbXG1CSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965509AbXG1CSy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 22:18:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933056AbXG1CSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 22:18:48 -0400
Received: from rv-out-0910.google.com ([209.85.198.189]:51885 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932619AbXG1CSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 22:18:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=GZNh++LUQ1kds8fq1RFjhYdEAg9x2B5BVm4yST0nnG6tWTORO6GB/cSsZLNzlAZwV/CvnfQTMOdX57d1v8XER7kfTEzDyfyQdujh6Tr+94696vVryZdH5DJQMdGj6UCZmMhrM1yBUVXl5PX56BgTbDjvblhHjHU1kPJpe1bobEc=
Subject: Re: Problems with framebuffer in 2.6.22-git17
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Adrian McMenamin <adrianmcmenamin@gmail.com>
Cc: Adrian McMenamin <lkmladrian@gmail.com>, linux-kernel@vger.kernel.org,
       lethal@users.sourceforge.net
In-Reply-To: <1185588887.26603.42.camel@daplas>
References: <92a12cdb0707221141i4398d6fdxa7994c5f1f809b0a@mail.gmail.com>
	 <8b67d60707241445l2764d9f1odb72848342135048@mail.gmail.com>
	 <1185406433.5046.23.camel@daplas>
	 <92a12cdb0707271247s727993b8i33999a9652b2ca20@mail.gmail.com>
	 <92a12cdb0707271318t141ee32bs69cb9dab22eabba2@mail.gmail.com>
	 <1185571890.26603.7.camel@daplas>
	 <92a12cdb0707271525i46970157ke1b2b2e6575682d6@mail.gmail.com>
	 <1185578576.26603.16.camel@daplas>
	 <92a12cdb0707271732l1d61f0aajfbd72c62d7ded3b6@mail.gmail.com>
	 <1185583925.26603.24.camel@daplas>
	 <92a12cdb0707271806q60fcaa91s77a628b31cd65b4d@mail.gmail.com>
	 <1185588887.26603.42.camel@daplas>
Content-Type: text/plain
Date: Sat, 28 Jul 2007 10:18:38 +0800
Message-Id: <1185589118.26603.45.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-07-28 at 10:14 +0800, Antonino A. Daplas wrote:
> On Sat, 2007-07-28 at 02:06 +0100, Adrian McMenamin wrote:
> > On 28/07/07, Antonino A. Daplas <adaplas@gmail.com> wrote:
> > 
> > >

> tmp = transp << var->transp.offset | red << var->red.offset |
> 	green << var->green.offset | blue << var->green.offset;
>  

The above should be:

tmp = regno << var->transp.offset | regno << var->red.offset |
	regno << var->green.offset | regno << var->green.offset;
 
Tony

