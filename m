Return-Path: <linux-kernel-owner+w=401wt.eu-S1754043AbYJ2AZ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043AbYJ2AZ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 20:25:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753218AbYJ2AZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 20:25:47 -0400
Received: from smtp107.mail.mud.yahoo.com ([209.191.85.217]:36085 "HELO
	smtp107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753314AbYJ2AZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 20:25:47 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ZaNBTdJwXhSOcmCKoyo/qYIaUmEBRxQGEBZkfuCY+A/DD+p8p7JAexmTY+KlRIetOsv+wwucrXhlt4NGvQdx7c4RxU0pqXyS6D7hfjpRl2RnQseoxqMtEAQkLiXUJVPQCttIMG8+DYtH7YQVGTBzHLnFpTHj6XKRfNG6nCpwu60=  ;
X-YMail-OSG: PMfO_OEVM1lUORKOCEDMO9c4nIos.ap8OYRrXqvWHE9LLFNT.BzJeiLqcPMX7gQJmvEKC6GCjlhAc8kaP6V4l2CeZVpSH6cBfu53Sm5Owfio8xIOEwGUvGC34d3aY99CV_93WjXD9jBBmQMlM8b4JcpdabpP7jRw0eyfD1Frlayl9ZGUwZKSK3Pjd97K
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: WARNING: at fs/buffer.c:1186 mark_buffer_dirty+0x51/0x66()
Date: Wed, 29 Oct 2008 11:25:31 +1100
User-Agent: KMail/1.9.5
Cc: linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org
References: <4901F375.3020202@vlnb.net> <200810282342.05172.nickpiggin@yahoo.com.au> <49076A36.5040802@vlnb.net>
In-Reply-To: <49076A36.5040802@vlnb.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810291125.31547.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 October 2008 06:38, Vladislav Bolkhovitin wrote:
> Nick Piggin wrote:
> > On Saturday 25 October 2008 03:10, Vladislav Bolkhovitin wrote:
> >> Hi,
> >>
> >> During recent debugging session of my SCSI target SCST
> >> (http://scst.sf.net) I noticed many
> >>
> >> WARNING: at fs/buffer.c:1186 mark_buffer_dirty+0x51/0x66()
> >>
> >> messages in kernel log on the initiator. I attached the full log of
> >> several of them.
> >>
> >> My target was buggy and I was working on fixing it, but I suppose Linux
> >> should handle such failures more gracefully. In all the cases the target
> >> had one type of failure: it "ate" a SCSI command and never returned
> >> result of it.
> >
> > Right. This is one of the warnings I see in my fault-injection testing.
> > It is fixed by my patch to clean up and improve the page and buffer
> > error handling in the vm/fs.
>
> Can you specify which patch you referring? Is it in 2.6.27?

It's just an RFC at the moment which I posted to fsdevel. Not in 2.6.27.
