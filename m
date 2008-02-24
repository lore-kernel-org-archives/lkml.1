Return-Path: <linux-kernel-owner+w=401wt.eu-S1752276AbYBXPSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752276AbYBXPSW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 10:18:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752092AbYBXPSK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 10:18:10 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:52471 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbYBXPSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 10:18:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:sender;
        b=DGnJIFFX/pA+Aeh5aTkYf41BaKp2R0Nc+RPQNNOW0NzzF6BTATJYLjUuFmy5dbbMZaglyFAhs+X0zPe8JSP0hWcvShY0pHPqNK+jZQesLcIG8R5Z7Q+umeG7Ejxrl55qH5pgmK1MVrMRGPK+xfeJ4X5Ed19hwergfmfiPxeVut4=
Message-ID: <47C18AAB.7050503@panasas.com>
Date: Sun, 24 Feb 2008 07:18:03 -0800
From: Benny Halevy <bhalevy@panasas.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andy Whitcroft <apw@shadowen.org>
CC: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Change a WARN message in checkpatch
References: <20080114232913.2555d392@paolo-desktop>	 <20080128145605.GI12910@shadowen.org>	 <4d8e3fd30801280713n7139223fj91adca85c76b60ad@mail.gmail.com> <4d8e3fd30802230538k7be1cc6bja9130e65fc6f5997@mail.gmail.com>
In-Reply-To: <4d8e3fd30802230538k7be1cc6bja9130e65fc6f5997@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb. 23, 2008, 5:38 -0800, "Paolo Ciarrocchi" <paolo.ciarrocchi@gmail.com> wrote:
> On Mon, Jan 28, 2008 at 4:13 PM, Paolo Ciarrocchi
> <paolo.ciarrocchi@gmail.com> wrote:
>> On Jan 28, 2008 3:56 PM, Andy Whitcroft <apw@shadowen.org> wrote:
>>  > On Mon, Jan 14, 2008 at 11:29:13PM +0100, Paolo Ciarrocchi wrote:
>>  > > Hi Andy,
>>  > > When I started using checkpatch I was confused by the following WARN message:
>>  > >
>>  > >       no space between function name and open parenthesis
>>  > >
>>  > > I thought the problem was that a space was missing while the truth is the opposite.
>>  > >
>>  > > How about the following patch?
>>  >
>>  > I can see how that language would be confusing.  Your patch makes the
>>  > english clearer, but somehow seems clumsy.  There must be a better way
>>  > to say this.  I will think on it and see what I can come up with.
>>
>>  Fair enought, I'm not English mother tongue and I'm sure you can come
>>  up with a better
>>  sentence :-)
> 
> AFAICS the problem is still present.
> 
> Ciao,

How about:
-				WARN("no space between function name and open parenthesis '('\n" . $herecurr);
+				WARN("there should be no space between function name and open parenthesis '('\n" . $herecurr);

The original phrasing can be interpreted like "there is no space between ..." and the correct
interpretation should be "there should be no space between ..."

Benny
