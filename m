Return-Path: <linux-kernel-owner+w=401wt.eu-S1030413AbXD1VMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030413AbXD1VMm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 17:12:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030726AbXD1VMm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 17:12:42 -0400
Received: from nz-out-0506.google.com ([64.233.162.238]:62934 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030413AbXD1VMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 17:12:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=f9OcxpKsLnmpi+92mmuFkMnO1UIVtMzIrjfFf/Eqdb2gHsn2c07ZEOAqzkE1PaqweeIp6zdLbhEk8YLDxowu5OLn1DglsqCTQYnd5fquJ86FNQVTE04cywdT7MrkyaZ4tnXvnpRO1JW79n17aeJuefCqdaF18PCIpgJE504zoig=
Message-ID: <75b66ecd0704281412x33352e97kc9c646ea594ef9ee@mail.gmail.com>
Date: Sat, 28 Apr 2007 17:12:34 -0400
From: "Lee Revell" <rlrevell@joe-job.com>
To: "Mikulas Patocka" <mikulas@artax.karlin.mff.cuni.cz>
Subject: Re: [ext3][kernels >= 2.6.20.7 at least] KDE going comatose when FS is under heavy write load (massive starvation)
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Mike Galbraith" <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Jens Axboe" <jens.axboe@oracle.com>,
       "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0704282242280.16099@artax.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1177660767.6567.41.camel@Homer.simpson.net>
	 <20070427013350.d0d7ac38.akpm@linux-foundation.org>
	 <Pine.LNX.4.64.0704282242280.16099@artax.karlin.mff.cuni.cz>
X-Google-Sender-Auth: e35a2cc71c28a908
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/28/07, Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz> wrote:
> I most wonder, why vim fsyncs its swapfile regularly (blocking typing
> during that) and doesn't fsync the resulting file on :w  :-/

Never seen this.  Why would fsync block typing unless vim was doing
disk IO for every keystroke?

Lee
