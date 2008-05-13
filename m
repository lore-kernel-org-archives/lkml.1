Return-Path: <linux-kernel-owner+w=401wt.eu-S1758326AbYEMQ7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758326AbYEMQ7T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 12:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754644AbYEMQ7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 12:59:11 -0400
Received: from nn7.de ([85.214.94.156]:41783 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752909AbYEMQ7K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 12:59:10 -0400
Subject: Re: how to empty buffers/cache?
From: Soeren Sonnenburg <kernel@nn7.de>
To: Alejandro Riveira =?ISO-8859-1?Q?Fern=E1ndez?= 
	<ariveira@gmail.com>,
       "Carlos R\. Mafra" <crmafra2@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20080510001124.6bc3a5c6@Varda>
References: <1210369787.4142.24.camel@localhost>
	 <20080510001124.6bc3a5c6@Varda>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Date: Tue, 13 May 2008 18:58:16 +0200
Message-Id: <1210697896.4964.104.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-05-10 at 00:11 +0200, Alejandro Riveira Fernández wrote:
> El Fri, 09 May 2008 21:49:47 +0000
> Soeren Sonnenburg <kernel@nn7.de> escribió:
> 
> > Dear all,
> > 
> > I am trying to perform some benchmarks that involve reading the same big
> > file a couple of times from disk. However I would want to make sure that
> > the file is not buffered/cached by the kernel when I read the file a
> > second/third/etc time.
> > 
> > Is there a way (except rebooting/unmounting the disk) to clear the
> > buffers?
> 
>  echo 3  > /proc/sys/vm/drop_caches IIRC

thank you both very much ( echo 3 > ... is what I was looking for)

Soeren
