Return-Path: <linux-kernel-owner+w=401wt.eu-S1754766AbYASU5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766AbYASU5b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 15:57:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751416AbYASU5Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 15:57:25 -0500
Received: from [212.12.190.230] ([212.12.190.230]:35988 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751359AbYASU5Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 15:57:24 -0500
From: Al Boldi <a1426z@gawab.com>
To: "Oliver Pinter (=?iso-8859-1?q?Pint=E9r?= =?iso-8859-1?q?=20Oliv=E9r?=)" 
	<oliver.pntr@gmail.com>
Subject: Re: konqueror deadlocks on 2.6.22
Date: Sat, 19 Jan 2008 23:57:13 +0300
User-Agent: KMail/1.5
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <200801192114.41427.a1426z@gawab.com> <6101e8c40801191053j7e81988fm8aaf0a75fb8bd405@mail.gmail.com>
In-Reply-To: <6101e8c40801191053j7e81988fm8aaf0a75fb8bd405@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <200801192357.13774.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver Pinter (Pintér Olivér) wrote:
> This kernel is vanilla 2.6.22.y or with CFS?

Yes with CFSv20.4, as in the log.

It also hangs on 2.6.23.13

> On 1/19/08, Al Boldi <a1426z@gawab.com> wrote:
> > I was just attacked by some deadlock issue involving sqlite3 and
> > konqueror. While sqlite3 continues to slowly fill a 7M-record db in
> > transaction mode, konqueror hangs for a few minutes, then continues only
> > to hang again and again.
> >
> > Looks like an fs/blockIO issue involving fsync.
> >
> > As a workaround, is there a way to make fsync soft?


Thanks!

--
Al

