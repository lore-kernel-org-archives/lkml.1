Return-Path: <linux-kernel-owner+w=401wt.eu-S1755683AbYCQCpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755683AbYCQCpz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 22:45:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752873AbYCQCpr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 22:45:47 -0400
Received: from n6.bullet.mud.yahoo.com ([216.252.100.57]:40481 "HELO
	n6.bullet.mud.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752590AbYCQCpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 22:45:46 -0400
X-Yahoo-Newman-Id: 22876.29537.bm@omp424.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=0E/H8hVCjw2YvqsZMVbHtJ9n/yZZ98klIEkZ31JxEQgDE7F9aiExu9UwNTzaf3mqzc9rWzA1hf8ffA5c1K1eoXn/SoVOuI3lWvNdVETUvGBLn3LTFyyK091XpYQPG4DRIiSYFCNx7YS1ZzhkILK6uH6DOx3iCPKDD4lyCFa11uY=  ;
X-YMail-OSG: IRlcu8MVM1lW_mubNehu3KTn.Eb3fVyLq4uyIbBvOeTKlOKiASCalQxehTAu8utBMKSeRKYK5Q--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Adam Megacz <adam@megacz.com>
Subject: Re: question about PAE and buffercache
Date: Mon, 17 Mar 2008 13:27:44 +1100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <x3abl3sjf5.fsf@nowhere.com>
In-Reply-To: <x3abl3sjf5.fsf@nowhere.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803171327.45159.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 March 2008 08:48, Adam Megacz wrote:
> Sorry to ask here, but I looked around for quite a while on the web.
>
> Is the size of the buffercache in any way constrained by the amount of
> virtual memory space allocated to the kernel (when using a PAE kernel)?
>
> For example with a 1G/3G split and 8G of physical memory, if userspace
> processes aren't interested in more than 6G of that memory, would the
> kernel fully utilize all of the remaining 2G for buffercache?

No. It is indeed constrained by the amount of virtual memory space
the kernel has. So it could use in practice probably only around
700-800MB for buffercache.

