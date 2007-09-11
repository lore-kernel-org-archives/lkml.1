Return-Path: <linux-kernel-owner+w=401wt.eu-S965423AbXIKWPT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965423AbXIKWPT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 18:15:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756029AbXIKWPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 18:15:05 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:42227 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826AbXIKWPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 18:15:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=SdAeUGj1wvX0LS0CEpX1cJC3gmcU53lk5mxKHD6G+13W3n03buJP1jD8J7c6BcvXEui2RlTteg1MTeRFPq/Am32Z6wY1qfoE0mN8M+dMGOyRvW/+eOWqJ/Flm37pHYmVcxwXnZZ7kE6MFf/os2e0f5XNupxl3t+9R2qm78QJ6hk=
Message-ID: <8b67d60709111515m5b45c57emef5cc2f74795ed7a@mail.gmail.com>
Date: Tue, 11 Sep 2007 23:15:01 +0100
From: "Adrian McMenamin" <lkmladrian@gmail.com>
To: "Rene Herman" <rene.herman@gmail.com>
Subject: Re: time_after - what on earth???
Cc: linux-kernel@vger.kernel.org, linuxsh-dev@lists.sourceforge.net,
       "Paul Mundt" <lethal@linux-sh.org>
In-Reply-To: <46E7128D.1080006@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8b67d60709111505u61771a1do74c82a55430ec214@mail.gmail.com>
	 <46E7128D.1080006@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2007, Rene Herman <rene.herman@gmail.com> wrote:
> On 09/12/2007 12:05 AM, Adrian McMenamin wrote:
>
> > OK, why does this line occasionally return true:
> >
> >       if ((maple_dev->interval > 0) && (jiffies >maple_dev->when))
> >
> > while this one never does (no other changes made):
> >
> > if  ((maple_dev->interval > 0) && (time_after(jiffies, maple_dev->when)))
>
> Is maple_dev->when an unsigned long?
>
Yes. Does that make a difference?
