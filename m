Return-Path: <linux-kernel-owner+w=401wt.eu-S1757924AbYDJQDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757924AbYDJQDq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 12:03:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755629AbYDJQDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 12:03:37 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:4393 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755508AbYDJQDg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 12:03:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=qxqv1+9PKzH3a7WFXHZ8VDz7N0IFQ6wspBaZOh/W0I4Bz9tFC3aNsnmazdFSwEBknmBp/RaaL3b5GE1y+IXhltg/x8s9+3ZWFl5zTOjD8VW1EcYwTUlKxoAkWhSZKLwG0bbG9z8dk1q1okp5Nd2hqvvV1G+d6J+UKp3p0j3kjo0=
Date: Thu, 10 Apr 2008 18:03:35 +0200
From: Diego Calleja <diegocg@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Jan Kara <jack@suse.cz>, Michal Hocko <mhocko@suse.cz>,
       Meelis Roos <mroos@linux.ee>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: file offset corruption on 32-bit machines?
Message-Id: <20080410180335.6a748c78.diegocg@gmail.com>
In-Reply-To: <Pine.LNX.4.64.0804101628000.3896@jikos.suse.cz>
References: <Pine.SOC.4.64.0804081101430.28938@math.ut.ee>
	<200804101555.58643.mhocko@suse.cz>
	<Pine.LNX.4.64.0804101558280.26562@twin.jikos.cz>
	<20080410142700.GC6725@atrey.karlin.mff.cuni.cz>
	<Pine.LNX.4.64.0804101628000.3896@jikos.suse.cz>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Thu, 10 Apr 2008 16:31:09 +0200 (CEST), Jiri Kosina <jkosina@suse.cz> escribió:

> I think this is worth fixing.

This question comes very often, and Linus even wrote a patch
(http://lkml.org/lkml/2006/4/13/124 , http://lkml.org/lkml/2006/4/13/130)

But apparently there's no much interest in fixing it, because it would
slow down some workloads...
