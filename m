Return-Path: <linux-kernel-owner+w=401wt.eu-S1762661AbYEAQLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762661AbYEAQLS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 12:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755424AbYEAQLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 12:11:10 -0400
Received: from fmmailgate04.web.de ([217.72.192.242]:45996 "EHLO
	fmmailgate04.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753156AbYEAQLJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 12:11:09 -0400
Date: Thu, 01 May 2008 18:11:07 +0200
Message-Id: <261643149@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: linux-kernel@vger.kernel.org
Subject: Re: RFC: starting a kernel-testers group for newbies
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX1+RXnl9ou/QqP1b2cGrOqeHjARMGM56c1YX1oinbHp/2bgP6
 XHQfhO/wU+bEzqf6H9h7A3exdSZLAHLAslHY0ACWtB3hFCbsE0=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>I'll try to do this:
>- create some Wiki page
>- get a mailing list at vger
>- point newbies to this mailing list
>- tell people there which kernels to test
>- figure out and document stuff like how to bisect between -next kernels
>- help them to do whatever is required for a proper bug report

good idea :)

one more:
reported bugs sometimes get lost in lkml (or elsewhere) and may not get the attention they need.

maybe there are not enough people who put some steadiness into tracking bugs (i.e. put them in bugzilla and make sure they get tracked/resolved) ?

isn`t that something for kernel-testers, too ?

i`m quite sure that there are people among them who have fun with helping tracking bugs, even if they lack proper programming skills.
imho, it`s not only a matter of knowledge, but maybe manpower, too.
  
so, wouldn`t it be helpful if there were more people helping the kernel-developers saving time, e.g. by take over the easier tasks like asking bug-reporters for input, help collection of debug-data, help assigning bugs to the right people etc.....






List:       linux-kernel
Subject:    RFC: starting a kernel-testers group for newbies
From:       Adrian Bunk <bunk () kernel ! org>
Date:       2008-05-01 0:31:25
Message-ID: 20080501003125.GM29330 () cs181133002 ! pp ! htv ! fi
[Download message RAW]

On Wed, Apr 30, 2008 at 01:31:08PM -0700, Linus Torvalds wrote:
> 
> 
> On Wed, 30 Apr 2008, Andrew Morton wrote:
> > 
> > <jumps up and down>
> > 
> > There should be nothing in 2.6.x-rc1 which wasn't in 2.6.x-mm1!
> 
> The problem I see with both -mm and linux-next is that they tend to be 
> better at finding the "physical conflict" kind of issues (ie the merge 
> itself fails) than the "code looks ok but doesn't actually work" kind of 
> issue.
> 
> Why?
> 
> The tester base is simply too small.
> 
> Now, if *that* could be improved, that would be wonderful, but I'm not 
> seeing it as very likely.
> 
> I think we have fairly good penetration these days with the regular -git 
> tree, but I think that one is quite frankly a *lot* less scary than -mm or 
> -next are, and there it has been an absolutely huge boon to get the kernel 
> into the Fedora test-builds etc (and I _think_ Ubuntu and SuSE also 
> started something like that).
> 
> So I'm very pessimistic about getting a lot of test coverage before -rc1.
> 
> Maybe too pessimistic, who knows?

First of all:
I 100% agree with Andrew that our biggest problems are in reviewing code 
and resolving bugs, not in finding bugs (we already have far too many 
unresolved bugs).

But although testing mustn't replace code reviews it is a great help, 
especially for identifying regressions early.

Finding testers should actually be relatively easy since it doesn't 
require much knowledge from the testers.

And it could even solve a second problem:

It could be a way for getting newbies into kernel development.

We actually do only rarely have tasks suitable as janitor tasks for 
newbies, and the results of people who do neither know the kernel
nor know C running checkpatch on files in the kernel have already
been discussed extensively...

I'll try to do this:
- create some Wiki page
- get a mailing list at vger
- point newbies to this mailing list
- tell people there which kernels to test
- figure out and document stuff like how to bisect between -next kernels
- help them to do whatever is required for a proper bug report

> 		Linus

cu
Adrian

-- 




______________________________________________________
Bis 50 MB Dateianhänge? Kein Problem!
http://freemail.web.de/club/landingpage.htm/?mc=025556

