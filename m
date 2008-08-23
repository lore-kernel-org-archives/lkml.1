Return-Path: <linux-kernel-owner+w=401wt.eu-S1753442AbYHWFwP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442AbYHWFwP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 01:52:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751678AbYHWFwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 01:52:07 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:51964 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbYHWFwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 01:52:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=vyp8NCLy+46x4WQJFp5KMjRHDkb5DlcDRfpd8nDdIa2k8N6xR1x0jBj9EXhP103r0d
         yPoo+zoqFeI7+cLmzCC+EA4VJxeIcTDFEq7vF5DUpOfT6bROp/BT6kQ8IlwRlVIf0IvM
         Uh0E5L7VYU3rX0kSE1HXzzaTfEtGJklVMUwwc=
Message-ID: <86802c440808222252j6f900f1dlfbf1378a7bc35ee4@mail.gmail.com>
Date: Fri, 22 Aug 2008 22:52:05 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Joshua Hoblitt" <j_kernel@hoblitt.com>
Subject: Re: [Bug 11388] New: 2.6.27-rc3 warns about MTRR range; only 3 of 16gb of memory is usable
Cc: "Ingo Molnar" <mingo@elte.hu>, "Andrew Morton" <akpm@linux-foundation.org>,
       bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080823002235.GL23377@hoblitt.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080822002952.GG23377@hoblitt.com>
	 <20080822011055.GI23377@hoblitt.com>
	 <86802c440808211855h50ea65faudc169e48f83e18e2@mail.gmail.com>
	 <20080822021512.GJ23377@hoblitt.com>
	 <86802c440808211926k1ec5b2a2g2bec1b7faee7ebbb@mail.gmail.com>
	 <86802c440808212024v3ccd2a7ey6517c180464275f0@mail.gmail.com>
	 <20080822035024.GB30284@elte.hu> <20080822035609.GD30284@elte.hu>
	 <86802c440808212148k74e56fa2mdb2e329ed4df1271@mail.gmail.com>
	 <20080823002235.GL23377@hoblitt.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2008 at 5:22 PM, Joshua Hoblitt <j_kernel@hoblitt.com> wrote:
> I've confirmed that the boards in these systems are Tyan Tempest i5400PW
> (S5397)s.  We've discovered a workload that will deadlock the system
> under both 2.6.24.2 and -tip kernel with the mtrr masking patch.  The
> only thing unusual about this workload is that one of the binaries in
> it constantly segvs...  Is it possible that these deadlocks (no kernel
> oops on console) are caused by MSR setup wierdness or is it likely unrelated?

could be other problem.

cpu should be smarter enough to understand the missing bits in mask.
at least amd cpu. remember that we didn't set mask bits to 40bits with
opteron with LinuxBIOS, and everything still works well.

YH
