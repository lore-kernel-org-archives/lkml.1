Return-Path: <linux-kernel-owner+w=401wt.eu-S1761127AbYGaAHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761127AbYGaAHr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 20:07:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760893AbYGaAHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 20:07:13 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:31288 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758460AbYGaAHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 20:07:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=OppC1FGDW9KXIxwakp3dk2H1bGvjv38FUnM3PgXVKnz7jSAMwOai6SiA9bZfGiq/8v
         nsbq1BbgFSkhElhuAW0C88MM83tPmSeeubO4hfXFjjXQ9aL7mOApncukAunBYyqByl3H
         pd3o0RqxtXi4Dmpo/wb80AV57yACpiWrO7icM=
Message-ID: <75b66ecd0807301707x9fbcfe6na91abd70c2d7d652@mail.gmail.com>
Date: Wed, 30 Jul 2008 20:07:10 -0400
From: "Lee Revell" <rlrevell@joe-job.com>
To: shuey@purdue.edu
Subject: Re: high latency NFS
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200807241311.31457.shuey@purdue.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200807241311.31457.shuey@purdue.edu>
X-Google-Sender-Auth: 6d3e417fc21ac778
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2008 at 1:11 PM, Michael Shuey <shuey@purdue.edu> wrote:
> NFS mount is tcp, version 3.  rsize/wsize are 32k.  Both client and server
> have had tcp_rmem, tcp_wmem, wmem_max, rmem_max, wmem_default, and
> rmem_default tuned - tuning values are 12500000 for defaults (and minimum
> window sizes), 25000000 for the maximums.  Inefficient, yes, but I'm not
> concerned with memory efficiency at the moment.

Try using UDP.  I had to move a 10TB+ data warehouse over a 100Mbit
WAN link not long ago and this was the only method that gave me close
to wire speed.

Lee
