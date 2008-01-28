Return-Path: <linux-kernel-owner+w=401wt.eu-S1759529AbYA1PQF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759529AbYA1PQF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 10:16:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755389AbYA1PPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 10:15:53 -0500
Received: from fk-out-0910.google.com ([209.85.128.189]:9849 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754812AbYA1PPw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 10:15:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=eZXkFgFi+gqduP0my79FzvgF8ZXaYTpQ63uDZcf0Jm4VjL3yloV4fHnl1pIGgg7Ph6q2Hp40n9gSMb22ocdTavpZmXcwSJDfGuQ+0MO9V0i4SHIcNU2HuWTCpzHyA8Y7T/cuMtVHy0zW3uebdmi18DKL5EZMtDoXeCURNabpaVo=
Date: Mon, 28 Jan 2008 16:13:58 +0100
From: Diego Calleja <diegocg@gmail.com>
To: Andi Kleen <ak@suse.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Trond Myklebust <Trond.Myklebust@netapp.com>,
       Steve French <smfrench@gmail.com>, swhiteho@redhat.com,
       sfrench@samba.org, vandrove@vc.cvut.cz, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] [8/18] BKL-removal: Remove BKL from remote_llseek
Message-Id: <20080128161358.b1577b66.diegocg@gmail.com>
In-Reply-To: <200801281510.35200.ak@suse.de>
References: <20080127317.043953000@suse.de>
	<200801281427.36048.ak@suse.de>
	<20080128133857.6c53ac9f@core>
	<200801281510.35200.ak@suse.de>
X-Mailer: Sylpheed 2.4.5 (GTK+ 2.12.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Mon, 28 Jan 2008 15:10:34 +0100, Andi Kleen <ak@suse.de> escribió:

> So you get overlapping reads. Probably not good.

This was discussed in the past i think ->

http://lkml.org/lkml/2006/4/13/124
http://lkml.org/lkml/2006/4/13/130
