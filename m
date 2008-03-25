Return-Path: <linux-kernel-owner+w=401wt.eu-S1757372AbYCYQi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757372AbYCYQi0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 12:38:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751830AbYCYQiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 12:38:19 -0400
Received: from n1b.bullet.mail.ac4.yahoo.com ([76.13.13.71]:45651 "HELO
	n1b.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752023AbYCYQiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 12:38:18 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 273367.9202.bm@omp105.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=X-YMail-OSG:Received:Date:From:Subject:To:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=6l4TlxhIQU8DEwealLu68dH0qRJssxe+t86RZO40VPjE/BW0qD11yoZotibYoOuwSsqWNxS7T0T+gRKLnUXYwv4kJfKTozTtKxOv1SgC8Gneg213mM23rB049d/iUFpox2j7i34tlwdj4E+YMAOg0qUqdR5t5EEMBs5QukkobJI=;
X-YMail-OSG: PScHljwVM1ljefr3AltxM29cOsKf2XSwR7dTsmzoY5s3pl50NMFH1YX685S8xZWkgZqhL5mlZja7q9ejwABKFmjCkUIUd3FyxxegXnoxI9sfSEonvd7JePEMJhc-
Date: Tue, 25 Mar 2008 17:38:15 +0100 (CET)
From: Michael Meyer <mike65134@yahoo.de>
Subject: Re: performance differences: "maxcpus=1" vs. "echo 0 > /sys/devices/system/cpu/cpu1/online"
To: linux-kernel@vger.kernel.org
In-Reply-To: <20080325140825.GA19722@bit.office.eurotux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <22851.90444.qm@web25806.mail.ukl.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Luciano Rocha <luciano@eurotux.com> schrieb:

> 
> On Tue, Mar 25, 2008 at 02:47:50PM +0100, Michael
> Meyer wrote:
> > Hi, 
> > 
> > what is the difference between booting a dual core
> > machine with "maxcpus=1" or by deactivating the
> second
> > core at run time with "echo 0 >
> > /sys/devices/system/cpu/cpu1/online"?
> 
> maxcpus=1 should turn off the SMP alternative and
> switch to UP only,
> optimising some locks and instructions.

Can this be achieved during runtime also? And is it
possible to switch back to SMP after that?


      Lesen Sie Ihre E-Mails jetzt einfach von unterwegs.
www.yahoo.de/go

