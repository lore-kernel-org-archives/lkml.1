Return-Path: <linux-kernel-owner+w=401wt.eu-S934368AbYETPno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934368AbYETPno (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 11:43:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933560AbYETPmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 11:42:46 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:62222 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933449AbYETPmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 11:42:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=e0BuNle6xDUf7KGeSaCx2Sz0VhbPvverRhuzPJz6Vrpc18giZi2qs86V/rdBK7NLmKKkKbHoW2oOcqS8SvgVfNMNTBHMb1KbBGwOukbDZX0lCD/3JwmKi064DM1cn8KsxavnjNiwT6BD1wXaQyCQmeK4Nz5vtxgNRN139O6I6E4=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Anas Nashif <nashif@linux.intel.com>
Subject: Re: [PATCH] Intel Management Engine Interface
Date: Tue, 20 May 2008 18:42:21 +0300
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <4832174A.20905@linux.intel.com>
In-Reply-To: <4832174A.20905@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805201842.22014.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 20 May 2008 03:11:54 Anas Nashif wrote:
> We have addressed more issues raised on lkml after initial submission,
> especially the legacy device support issue which was removed in this
> patch.
> 
> The Intel Management Engine Interface (aka HECI: Host Embedded
> Controller Interface ) enables communication between the host OS and
> the Management Engine firmware. MEI is bi-directional, and either the
> host or Intel AMT firmware can initiate transactions.
> 
> The core hardware architecture of Intel Active Management Technology
> (Intel AMT) is resident in firmware. The micro-controller within the
> chipset's graphics and memory controller (GMCH) hub houses the
> Management Engine (ME) firmware, which implements various services
> on behalf of management applications.
> 
> Some of the ME subsystems that can be access via MEI driver:
> 
> - Intel(R) Quiet System Technology (QST) is implemented as a firmware
> subsystem  that  runs in the ME.  Programs that wish to expose the
> health monitoring and fan speed control capabilities of Intel(R) QST
> will need to use the MEI driver to communicate with the ME sub-system.
I bought a system with intel DG965RY motherboard year ago, and still no support for its
O/B sensors in linux.

Can I ask again, when you expect it to be released.
At least intel should release documents how to access the QST sensors.

I know that HECI is first step for that, but it is not enought to read those sensors.

I Really hope there are good news,
	Best regards,
		Maxim Levitsky
