Return-Path: <linux-kernel-owner+w=401wt.eu-S932725AbXBWUfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932725AbXBWUfk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 15:35:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932833AbXBWUfk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 15:35:40 -0500
Received: from wr-out-0506.google.com ([64.233.184.227]:61443 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932725AbXBWUfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 15:35:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=k2Zg6clLqamGgSC7SIe5yUH3ciK2AehYN+pdprAIfwhcjlJ8O3UX6jbGvlXYFCRBGwYLL0CDlMWvnNA8NWDXpfJzqWzj8+oyD5T7let29z7AZKgAGjNUUuKamJ6dPn3iRTBNY9kX0l1Q/IsH6/MBXkkBtd092bv/BTuras/VEuA=
Message-ID: <e5ab0f710702231235ucb559eerb3639ec312aa312a@mail.gmail.com>
Date: Fri, 23 Feb 2007 21:35:37 +0100
From: "Francesco Pretto" <ceztko@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Weird hard disk noise on shutdown (bug #7674)
In-Reply-To: <45DD0348.5040005@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa.Ia7dfo7Zd5kB6KhSYisfswa1aj4@ifi.uio.no>
	 <fa.YHt2nIlQmoW5r2enmTSzsaySwH4@ifi.uio.no> <45DD0348.5040005@shaw.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/2/22, Robert Hancock <hancockr@shaw.ca>:
>
> I believe it runs on suspend, but we don't run that code on normal
> shutdown, do we?
>
> Tejun Heo had a patch for sd that could (optionally) trigger a START
> STOP UNIT command to spin the disk down after synchronizing the cache
> before shutdown, but I haven't heard anything of it lately..
>
>

Was this?
http://www.nabble.com/(fwd)--PATCH--sd:-implement-stop_on_shutdown-t3049703.html

Not ready for inclusion yet? Tomorrow i'll give it a try, hoping it
will apply to my conf. My actually shutdown procedure is to reboot on
windows Xp and shutdown from there: i'm starting to become
frustrated...
