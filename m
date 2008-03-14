Return-Path: <linux-kernel-owner+w=401wt.eu-S1755351AbYCNF7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351AbYCNF7W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 01:59:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752176AbYCNF7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 01:59:12 -0400
Received: from smtp122.sbc.mail.sp1.yahoo.com ([69.147.64.95]:20554 "HELO
	smtp122.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750779AbYCNF7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 01:59:12 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=nVcuD7kl7HoQD637UjkbHXnBV+g6g4WtsxKhb2L94Rouuj/DtaxkBO7cWytJ5KvWztzlEFeL8zYfk5dIxfUdqUwCLrQKS+Q2fRob1k4AMEiFG66djDuQz28FT4KYAzz6eCNd+JfF1C/VIBUgGaq8V0ygAdNxPiTor2q+YEQCI80=  ;
X-YMail-OSG: w3QrLiwVM1lFZw6ILl7U5SCI1QxvuhOibr5.K05Fz0EsrVVaNpgREs3FFSd8L7e2tKUI4Vz52w--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] [PATCH 0/2] PM: Remove legacy PM
Date: Thu, 13 Mar 2008 21:59:08 -0800
User-Agent: KMail/1.9.6
Cc: David Newall <davidn@davidnewall.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>, Ralf Baechle <ralf@linux-mips.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200803132351.19794.rjw@sisk.pl> <47DA0DDB.7010403@davidnewall.com>
In-Reply-To: <47DA0DDB.7010403@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803132259.09518.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 March 2008, David Newall wrote:
> > The first of the following two patches removes the legacy PM infrastructure
> > and the second one removes some of its remnants from the MIPS tree.
> 
> What does "legacy PM" mean?

It's stuff that's so ancient nobody uses it any more... it's been
deprecated over a year (f89bce3d9afc6b1fb898ae176df4962c1303ee86),
and at that time only one ancient (Amiga?) driver even tried to
use the notification scheme it provided.

Glad to see this finally go away!

- Dave
