Return-Path: <linux-kernel-owner+w=401wt.eu-S1756584AbXIEMef@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756584AbXIEMef (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 08:34:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754204AbXIEMe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 08:34:28 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:21045 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753984AbXIEMe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 08:34:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=Y0JK8xQVYKCU9la0hgICOl1HqSnjQRkcvHe0TZTuZLRrz3P+4E4DO/6/K0S1eaRxGp6vg7EnQPkTdtpihwRyUnQPQy0nVUcnYIfpg8KyuFriJWWycYwivLpHLArQKepx4tfBkz/i7anceBOSHJEyvesrHNXZGF8UF34R29XnuHw=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: "Daniel J Blueman" <daniel.blueman@gmail.com>
Subject: Re: file system for solid state disks
Date: Wed, 5 Sep 2007 13:34:14 +0100
User-Agent: KMail/1.9.1
Cc: "Jan Engelhardt" <jengelh@computergmbh.de>,
       "Richard Ballantyne" <richardballantyne@gmail.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
References: <6278d2220708230155j18248f2cr3cc697a7acbaa930@mail.gmail.com>
In-Reply-To: <6278d2220708230155j18248f2cr3cc697a7acbaa930@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709051334.14599.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 23 August 2007 09:55, Daniel J Blueman wrote:
> On 23 Aug, 07:00, Jan Engelhardt <jengelh@computergmbh.de> wrote:
> > On Aug 23 2007 01:01, Richard Ballantyne wrote:
> > >What file system that is already in the linux kernel do people recommend
> > >I use for my laptop that now contains a solid state disk?
> >
> > If I had to choose, the list of options seems to be:
> >
> > - logfs
> >   [unmerged]
> >
> > - UBI layer with any fs you like
> >   [just a guess]
> >
> > - UDF in Spared Flavor (mkudffs --media-type=cdrw --utf8)
> >   [does not support ACLs/quotas]
> 
> Isn't it that with modern rotational wear-levelling, re-writing hot
> blocks many times is not an issue, as they are internally moved around
> anyway? So, using a journalled filesystem such as ext3 is still good
> (robustness and maturity in mind).

Crap hardware (one which only _claim_ to do it) is out there,
and is typically cheaper, so users preferentially buy that ;)
--
vda
