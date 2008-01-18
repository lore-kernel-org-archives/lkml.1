Return-Path: <linux-kernel-owner+w=401wt.eu-S1760930AbYARMlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760930AbYARMlS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 07:41:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756944AbYARMlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 07:41:09 -0500
Received: from smtp-out.google.com ([216.239.45.13]:14624 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756275AbYARMlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 07:41:08 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=rFNex6oHMCA5jM28PN5NluBZRXAhrbXs3j82VJzG4MP0ePmwDEuobOsbMnLfT1Xow
	R1j0r7VdMRXqQn+SgyVEQ==
Message-ID: <6599ad830801180441o2d60ffc9s47de9362cda40282@mail.gmail.com>
Date: Fri, 18 Jan 2008 07:41:03 -0500
From: "Paul Menage" <menage@google.com>
To: "Dhaval Giani" <dhaval@linux.vnet.ibm.com>
Subject: Re: [PATCH] cgroup: limit block I/O bandwidth
Cc: "Andrea Righi" <righiandr@users.sourceforge.net>,
       "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080118123605.GB14339@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4790904F.5000101@users.sourceforge.net>
	 <20080118123605.GB14339@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 18, 2008 7:36 AM, Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:
> On Fri, Jan 18, 2008 at 12:41:03PM +0100, Andrea Righi wrote:
> > Allow to limit the block I/O bandwidth for specific process containers
> > (cgroups) imposing additional delays on I/O requests for those processes
> > that exceed the limits defined in the control group filesystem.
> >
> > Example:
> >   # mkdir /dev/cgroup
> >   # mount -t cgroup -oio-throttle io-throttle /dev/cgroup
>
> Just a minor nit, can't we name it as io, keeping in mind that other
> controllers are known as cpu and memory?

Or maybe "blockio"?

Paul
