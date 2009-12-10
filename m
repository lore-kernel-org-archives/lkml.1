Return-Path: <linux-kernel-owner+w=401wt.eu-S1759320AbZLJBOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759320AbZLJBOw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 20:14:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751412AbZLJBOt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 20:14:49 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:38594 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390AbZLJBOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 20:14:48 -0500
To: Mike Snitzer <snitzer@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Heinz Diehl <htd@fancy-poultry.org>,
       linux-kernel@vger.kernel.org, martin.petersen@oracle.com,
       Christian Borntraeger <borntraeger@de.ibm.com>, dm-devel@redhat.com
Subject: Re: todays git regression (2.6.32-04008.g3ff6a46): lot of device  mapper warnings
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <200912091049.12604.borntraeger@de.ibm.com>
	<20091209212516.GA6206@fancy-poultry.org>
	<20091209214501.GC8742@kernel.dk> <20091209220749.GD8742@kernel.dk>
	<170fa0d20912091656s31575d0cneaf899e1781bdc16@mail.gmail.com>
Date: Wed, 09 Dec 2009 20:14:03 -0500
In-Reply-To: <170fa0d20912091656s31575d0cneaf899e1781bdc16@mail.gmail.com>
	(Mike Snitzer's message of "Wed, 9 Dec 2009 19:56:46 -0500")
Message-ID: <yq1bpi7vdes.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4B204B74.01C8:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Mike" == Mike Snitzer <snitzer@gmail.com> writes:

Mike> On the surface I thought this might be the reason for the
Mike> warnings, but Martin's lcm() looks perfectly fine; can't see why
Mike> it would cause these warnings to appear all of a sudden... but I
Mike> figured I'd share.

The warning is caused by an error in stacking discard granularity.  I
have a fix but I'd like to run verify all my oddball alignment combos
before submitting.

-- 
Martin K. Petersen	Oracle Linux Engineering
