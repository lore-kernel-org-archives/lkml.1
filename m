Return-Path: <linux-kernel-owner+w=401wt.eu-S1755674AbYFCU32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755674AbYFCU32 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 16:29:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752490AbYFCU3S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 16:29:18 -0400
Received: from po-out-1718.google.com ([72.14.252.158]:55587 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443AbYFCU3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 16:29:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=og2ru12S/cASjwi38yNKyva52C21i6ydWdtxItUysOE2L+l7xDRIN91oURT8EqXUG/HCHRtKje/YDG430zF8Z9OZ3gjmQVk+KduCblmIGWk5j/lmQur17nbyjw6q+RKAlSMVtEz5FaG1f3gG+XE+0k+w9IpceMCOSrM4KiNCcP8=
Message-ID: <cfd18e0f0806031329n2ca9da38pdf3d5a2fe81d3748@mail.gmail.com>
Date: Tue, 3 Jun 2008 22:29:14 +0200
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: utimensat() non-conformances and fixes [v4] (patch)
Cc: mtk.manpages@gmail.com, linux-kernel@vger.kernel.org, hch@lst.de,
       miklos@szeredi.hu, viro@zeniv.linux.org.uk, jamie@shareable.org,
       drepper@redhat.com, linux-fsdevel@vger.kernel.org,
       subrata@linux.vnet.ibm.com
In-Reply-To: <20080603132231.1430f812.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48454F1D.6060507@gmail.com> <4845A606.6070005@gmail.com>
	 <20080603132231.1430f812.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 3, 2008 at 10:22 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Tue, 03 Jun 2008 22:13:58 +0200
> Michael Kerrisk <mtk.manpages@googlemail.com> wrote:
>
>> This patch fixes all of the utimensat() bugs outlined in my
>> previous mail.
>>
>> I could have split the patch out into a few pieces, but given
>> that it is not long, and all against a single file, I've made
>> one patch.  Let me know if you would like separate patches for
>> the pieces below.
>
> Well I think it would have been better, really.
>
> Right now someone (apparently me) needs to take the text from
> "utimensat() non-conformances and fixes [v4] (overview)" and weave it
> together with the text from "utimensat() non-conformances and fixes
> [v4] (patch)" to produce a vaguely coherent changelog.
>
> It all would be much saner and cleaner if each of these changes was in
> a self-contained diff which had its own standalone changelog, no?

Okay -- let me take a shot at it.  I'll try to get back to you in an hour or so.

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
