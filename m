Return-Path: <linux-kernel-owner+w=401wt.eu-S1754646AbYIPMzU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646AbYIPMzU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 08:55:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752821AbYIPMzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 08:55:05 -0400
Received: from smtp112.mail.mud.yahoo.com ([209.191.84.65]:28660 "HELO
	smtp112.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752916AbYIPMzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 08:55:04 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=yVNwQF2Er784iQ+nqyks8k1o63hF1ybhdTzkbWJxAOW7VItCwMqmPYp3MIbKOF0vqlEOHkP4FeqPgri67q+gtpRGJFc6aEJH6/ljsqkCG71VoLY5A+yz2C1jHEzZXZy0RDs033zDrngdqxZWXs4g5UT1QH0gONfHDIHEweugyls=  ;
X-YMail-OSG: 4.DSkOgVM1kGZhtEgNq3mGe2YsVtQVAOAcvjf3AfvWxrEQbviM8I_IXI9TvnyQvt3l_WhPqUhvzmwFxxIcxjKScuRb4dVlVWbCr1J0aPPlAvA55A0Op7.ew2tNMlKC7RR2k-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Michael Trimarchi <trimarchimichael@yahoo.it>
Subject: Re: [PATCH] VFS: make file->f_pos access atomic on 32bit arch
Date: Tue, 16 Sep 2008 22:54:21 +1000
User-Agent: KMail/1.9.5
Cc: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <58603.86657.qm@web26202.mail.ukl.yahoo.com>
In-Reply-To: <58603.86657.qm@web26202.mail.ukl.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809162254.21514.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 September 2008 21:11, Michael Trimarchi wrote:
> Hi,
>
> > +        if (offset != file_pos_read(file))
> > +            file_pos_write(file, offset);
> >         retval = offset;
> >     }
>
> Is not more efficient here a compare xchg operation?

The compiler should do it if it was.
