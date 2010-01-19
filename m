Return-Path: <linux-kernel-owner+w=401wt.eu-S1753932Ab0ASOxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932Ab0ASOxp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 09:53:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752805Ab0ASOxo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 09:53:44 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:64507 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289Ab0ASOxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 09:53:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Za9N7rETgkir/NhNt+w/+wY5TITt2FN2wce1CTqU6M/gAzT992p7HNlZOLnhbZpFQE
         qqODDMp05oZ0zTFAa2yRx2dz/3tEu8spZy3L14MYGjzDdsUV3GrJl80UfTSDE0gy7fYy
         5ir0aSzeaWpHTh3zOrr/y+6Hba/AoZ9nSm720=
Date: Tue, 19 Jan 2010 15:53:40 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: Joshua Pincus <joshua.pincus@gmail.com>, peterz@infradead.org,
       paulus@samba.org, acme@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: HW breakpoints perf_events request
Message-ID: <20100119145337.GC8061@nowhere>
References: <bc915a051001131745m6fb70dcbx29b9d35f6fd7106c@mail.gmail.com> <20100118174505.GB23680@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100118174505.GB23680@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 18, 2010 at 11:15:05PM +0530, K.Prasad wrote:
> Signal generation happens by default for all user-space breakpoint
> requests (and not just for ptrace requests).


Ah? That's not a good thing. We should be able to
set userspace breakpoints later on perf without
generating signals.

