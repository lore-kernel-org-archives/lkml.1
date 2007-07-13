Return-Path: <linux-kernel-owner+w=401wt.eu-S1759065AbXGMEef@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759065AbXGMEef (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 00:34:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751209AbXGMEe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 00:34:28 -0400
Received: from nz-out-0506.google.com ([64.233.162.237]:10440 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093AbXGMEe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 00:34:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=B8K9yRLIdH/VYtp2RqUSV/KOle5nzAtRbkQYQp0kepNjI88yUuPKi04IC8fwvmay+IAAH5OEFl8n4J+kvnzn5xzfU7wCxRa/23RdMqiBxJusiki7WgaBlRQ7XZBLzlGchYOqghnLgBJjhUcIzgN9tT2tDIacMlQfua6ZhVwzaWM=
Message-ID: <a8e1da0707122134vc3d967aq21b7ca7e136778d@mail.gmail.com>
Date: Fri, 13 Jul 2007 04:34:23 +0000
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Alistair John Strachan" <alistair@devzero.co.uk>
Subject: Re: Gmail and flowed text (was Re: Correction to LZO1X)
Cc: "Christoph Hellwig" <hch@infradead.org>,
       "Satyam Sharma" <satyam.sharma@gmail.com>,
       "Nitin Gupta" <nitingupta910@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <200707112205.26470.alistair@devzero.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a781481a0707110636l3b56a25j174603a5a8af3186@mail.gmail.com>
	 <20070711152144.GA1394@infradead.org>
	 <200707112205.26470.alistair@devzero.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>On 7/11/07, Alistair John Strachan <alistair@devzero.co.uk> wrote:
> On Wednesday 11 July 2007 16:21:44 Christoph Hellwig wrote:
> > On Wed, Jul 11, 2007 at 07:06:23PM +0530, Satyam Sharma wrote:
> > > Which leaves Gmail, but Gmail has the flowed text disease (that
> > > cannot be disabled) and although Gmail offers SMTP/POP, our evil
> > > proxy/NAT setup here wouldn't let me make any use of it to access
> > > it from some other MUA such as pine/mutt.
> >
> > Given the amount of google people here maybe someone can get this
> > piece of junk called gmail fixed?  If google claims they're not
> > evil they should stop sending broken patches around..
>
> It'd be nice if they stopped mangling headers too (spaces->tabs).
>
Yes, it's boring for gmail users, I generally read messages from gmail
web pages, and send patches via mutt with ssmtp.
1. write ~/.mutt/ssmpt.conf as follows:
mailhub=smtp.gmail.com:587
UseSTARTTLS=YES
UseTLS=YES
AuthUser=yourid@gmail.com
AuthPass=***
FromLineOverride=YES

2. write ~/.mutt/ssmpt script:
#!/bin/sh
/usr/sbin/ssmtp -C ~/.mutt/ssmtp.conf $@

3.add the follow line to ~/.mutt/muttrc
set sendmail="~/.mutt/ssmtp"

Regards
dave
