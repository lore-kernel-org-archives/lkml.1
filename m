Return-Path: <linux-kernel-owner+w=401wt.eu-S1760802AbYA0J7n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760802AbYA0J7n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 04:59:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758076AbYA0JvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 04:51:11 -0500
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:60230
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756770AbYA0JvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 04:51:10 -0500
Message-ID: <479C540A.8020003@qumranet.com>
Date: Sun, 27 Jan 2008 11:51:06 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: Joerg Roedel <joerg.roedel@amd.com>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [PATCH 8/8] SVM: add support for Nested Paging
References: <1201294393-22613-1-git-send-email-joerg.roedel@amd.com> <1201294393-22613-9-git-send-email-joerg.roedel@amd.com> <479C464E.2060009@qumranet.com> <20080127094147.GA32677@8bytes.org>
In-Reply-To: <20080127094147.GA32677@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel wrote:
>
>> What happens to lazy fpu if we don't trap cr0 changes?
>>
>> Perhaps it's worth disabling lazy fpu with npt.
>>     
>
> It should be implicitly disabled with npt because accesses to cr3 are
> not intercepted anymore. The svm_set_cr3 function is the only place
> which disables fpu switching.
>   

Okay.  We may want to investigate enabling it later, but no hurry now.

On the other hand, we want to trap cr0 so the guest can't control the 
cache disable bits.  Also cr4.pce and cr4.mce.

-- 
error compiling committee.c: too many arguments to function

