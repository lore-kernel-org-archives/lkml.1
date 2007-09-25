Return-Path: <linux-kernel-owner+w=401wt.eu-S1754424AbXIYBTB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424AbXIYBTB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 21:19:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754475AbXIYBSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 21:18:53 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:55014
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753462AbXIYBSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 21:18:52 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: [RFC] New kernel-message logging API
Date: Mon, 24 Sep 2007 20:18:49 -0500
User-Agent: KMail/1.9.6
Cc: "Joe Perches" <joe@perches.com>, holzheu@linux.vnet.ibm.com,
       LKML <linux-kernel@vger.kernel.org>,
       "Dick Streefland" <dick.streefland@altium.nl>
References: <19f34abd0709221227v67443c0bg2cd2010e5bd5a6c1@mail.gmail.com> <1190653250.2010.2.camel@localhost> <19f34abd0709241337t545b3433mdc336055e2fb8330@mail.gmail.com>
In-Reply-To: <19f34abd0709241337t545b3433mdc336055e2fb8330@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709242018.49321.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 24 September 2007 3:37:55 pm Vegard Nossum wrote:
> On 9/24/07, Joe Perches <joe@perches.com> wrote:
> > On Mon, 2007-09-24 at 18:43 +0200, Vegard Nossum wrote:
> > > Storing the format-string separately allows us to hash THAT instead of
> > > the formatted (ie. console output) message. Since this will never
> > > change from message to message, it can be looked up in a table or
> > > whatever and allow user-space to do translations without for example
> > > regular expressions.
> >
> > That hash will change with each linux version given the
> > inevitable spelling fixes, message reformatting and such.
>
> But we can keep the old ones too. That shouldn't be much of a problem.
> I mean, it probably wouldn't rely on a hash alone. The format string
> itself can be compared with the translation database.

I point out that the thread started with a comment about how to _reduce_ 
bloat.

Just sayin'.

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
