Return-Path: <linux-kernel-owner+w=401wt.eu-S932922AbZGPR5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932922AbZGPR5Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 13:57:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932897AbZGPR5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 13:57:23 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:36615 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932885AbZGPR5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 13:57:23 -0400
Date: Thu, 16 Jul 2009 23:27:15 +0530
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: tty related hangs with 2.6.31-rc3
Message-ID: <20090716175715.GA4292@skywalker>
References: <20090715132956.GA10004@skywalker> <20090715161142.55083da7@lxorguk.ukuu.org.uk> <20090715165308.GA5228@skywalker> <20090715204902.GA4205@skywalker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090715204902.GA4205@skywalker>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 16, 2009 at 02:19:02AM +0530, Aneesh Kumar K.V wrote:
> Hi Alan,
> 
> On Wed, Jul 15, 2009 at 10:23:08PM +0530, Aneesh Kumar K.V wrote:
> > On Wed, Jul 15, 2009 at 04:11:42PM +0100, Alan Cox wrote:
> > > On Wed, 15 Jul 2009 18:59:56 +0530
> > > "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:
> > > 
> > > > Hi,
> > 
> 
> I am finding a new error with emacs now. Now i am not sure how to explain the problem
> as a nice bug report. But anyhow i will try. emacs support a mode to compile different
> prg. So to reproduce write a small program something like below
> 
> main()
> {
> 	printf("%d\n", i);
> }
> 
> Now in emacs say ALT-x compile
> 
> use cc a.c command to compile. It is supposed to show the error messages in the compile
> window. With 2.6.30 it works fine. Where as 2.6.31-rc3 it doesn't list me any error. 
> My limitted understanding about emacs compile window is, it looks for error messages
> using pattern matching from the compile ouput. I guess it is missing some of the
> compile message output.
> 
> 
> sorry that the report is sparse. If you need any specific inforation let me know.

reverting the patch d945cb9cce20ac7143c2de8d88b187f62db99bdc fix the bug for me.
So i guess that would imply it is pty changes related

-aneesh
