Return-Path: <linux-kernel-owner+w=401wt.eu-S1757262AbYGNSRb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757262AbYGNSRb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 14:17:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756039AbYGNSRS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 14:17:18 -0400
Received: from rn-out-0910.google.com ([64.233.170.185]:29653 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755958AbYGNSRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 14:17:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=qmdtRc7T8B6tDWynSm96BRCysuae0Sk82U2Wm4iTfHp17sBKnvB4YqQy2PlDDo24TE
         b8cjCkt7dTSCRlmCd2WxFJlIgroMFff8StUrfy1GTeKgejjy+3inaFGZAfcYIRW3loha
         MYQ47rGTDYKD77xt2YxfWg6fA8gFHgqr1M1cY=
Message-ID: <86802c440807141117q218fdd61w1216dc6ded72252a@mail.gmail.com>
Date: Mon, 14 Jul 2008 11:17:16 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] x86: Find offset for crashkernel reservation automatically
Cc: "Bernhard Walle" <bwalle@suse.de>, "Vivek Goyal" <vgoyal@redhat.com>,
       kexec@lists.infradead.org, x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <m17iboz83v.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1214510048-21215-1-git-send-email-bwalle@suse.de>
	 <20080627133256.GB5801@redhat.com>
	 <86802c440807140011v728cc35fy2540b537ddca9844@mail.gmail.com>
	 <20080714112404.36783df5@halley.suse.de>
	 <m1od50ztoa.fsf@frodo.ebiederm.org>
	 <86802c440807141006o98afac8t66b0933d8acd2746@mail.gmail.com>
	 <m17iboz83v.fsf@frodo.ebiederm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2008 at 10:30 AM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> "Yinghai Lu" <yhlu.kernel@gmail.com> writes:
>
>> for 64bit, kdump can start from address above 4g with bzImage?
>
> I think the boot protocol was properly updated for that, it was in the
> original drafts.  A relocatable kernel with a 64bit entry point.
>
> I do know that the 64bit code is ready to do that.

but bzImage for 64bit still use 32bit entries, except kexec could
uncompress the bzImage like xen domain builder.

YH
