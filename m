Return-Path: <linux-kernel-owner+w=401wt.eu-S1753408AbXEXWlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408AbXEXWlx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 18:41:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750793AbXEXWlq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 18:41:46 -0400
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:48129 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750751AbXEXWlp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 18:41:45 -0400
Subject: Re: [RFC] LZO de/compression support - take 3
From: Richard Purdie <richard@openedhand.com>
To: Michael-Luke Jones <mlj28@cam.ac.uk>, akpm <akpm@linux-foundation.org>
Cc: Nitin Gupta <nitingupta910@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mm-cc@laptop.org
In-Reply-To: <726113DF-D952-401F-96EA-7A10B035604B@cam.ac.uk>
References: <4cefeab80705230127r58e8f9e1sa644092e95eb81eb@mail.gmail.com>
	 <0F6CEFD7-86F2-4903-B4F7-F723DF88BE9A@cam.ac.uk>
	 <4cefeab80705230439n6bbb1259le3c3b9704ce49b75@mail.gmail.com>
	 <624FD7A7-5552-415F-96D8-4353453EA2A3@cam.ac.uk>
	 <4cefeab80705230703vdb3c414s250a61c4c2d70c51@mail.gmail.com>
	 <1CF43BBC-79EF-449B-A398-AE374E399573@cam.ac.uk>
	 <4cefeab80705230721i492b5f1ehfa2d775344b1c04e@mail.gmail.com>
	 <726113DF-D952-401F-96EA-7A10B035604B@cam.ac.uk>
Content-Type: text/plain
Date: Thu, 24 May 2007 23:41:22 +0100
Message-Id: <1180046482.12821.42.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-23 at 15:33 +0100, Michael-Luke Jones wrote:
> On 23 May 2007, at 15:21, Nitin Gupta wrote:
> 
> > If somebody is up to including compression he must be having head  
> > to use the right
> > decompress version depending on this scenario :-)
> 
> By that logic, experienced kernel dev Richard Purdie is not up to  
> using compression (?!)
> 
> To me, it looks like an easy trap to fall into. And one that an  
> experienced dev *has* just fallen in to.

To be fair, I just altered resier4 to use the library functions and it
was someone else who chose to use the "unsafe" version. I did flag this
up on LKML when I saw it and the resier4 people are considering
changing. 

I've since promised to send a patch changing it to use the safe version.

I'll not send a "rename to unsafe" patch for the LZO core until Andrew
decides whether to drop the unsafe version entirely or not as per your
patch. If he doesn't due to the potential use by the compressed cache
people, I will send that patch.

Cheers,

Richard


