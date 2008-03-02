Return-Path: <linux-kernel-owner+w=401wt.eu-S1755738AbYCBStF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755738AbYCBStF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 13:49:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757621AbYCBSss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 13:48:48 -0500
Received: from el-out-1112.google.com ([209.85.162.178]:12204 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757444AbYCBSsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 13:48:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=pMZKKKO/PuGS+lcYOrZDN4+rwSUspPUfM1v3HKFeqVHQbUG0TGAM849GuKiX6ygTN2Kx9Qm7EY5IbH64HWGcMML11IF/RoAQHwYpZGKMHhQRYGqPDtZjcVopQu7mK3dWwIMyvoPcSZy0rSyj3M+6fkWb1lA4qq7WUZ6hSsT5j+k=
Message-ID: <6a89f9d50803021048v7a330bd6m82d553d80042c5aa@mail.gmail.com>
Date: Sun, 2 Mar 2008 19:48:45 +0100
From: "Stephane Marchesin" <marchesin@icps.u-strasbg.fr>
To: linuxppc-dev@ozlabs.org, "David Woodhouse" <dwmw2@infradead.org>,
       benh@kernel.crashing.org, paulus@samba.org, henrik.sorensen@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: V4L2: __ucmpdi2 undefined on ppc
In-Reply-To: <6a89f9d50802060639j4b3a8b7u4e4e596b010ee353@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.SOC.4.61.0612131359430.10721@math.ut.ee>
	 <1166053317.909.19.camel@praia>
	 <20061214195842.GA14041@athena.road.mcmartin.ca>
	 <1166362145.6714.53.camel@pmac.infradead.org>
	 <6a89f9d50802060639j4b3a8b7u4e4e596b010ee353@mail.gmail.com>
X-Google-Sender-Auth: d7f74bbd657287dc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/6/08, Stephane Marchesin <marchesin@icps.u-strasbg.fr> wrote:
>
>  We're hitting this i nouveau as well (http://nouveau.freedesktop.org),
>  since we make extensive use ot 64 bit ints. Over time, we've had a
>  number of reports on this issue, and at one point I read that it
>  should be fixed in gcc. But recently, a nouveau user on PPC32 (Henrik
>  in CC:) reported the issue again with gcc 4.2.3. Others have it on gcc
>  4.2.2 too:
>  http://bugs.freedesktop.org/show_bug.cgi?id=10547
>
>  So, the point of this email is to ask about the possibility of merging
>  in one of the __ucmpdi2 patches, like David's which is kept below for
>  reference. Most distros seem to ship with such a patch already, and it
>  seems that other drivers hit this as well.
>

So, could we have that thing in main tree ? It's not like it's
untested, most distros carry that, and a couple of arches provide
their own ucmpdi2 implementation already. It's also such a small
function...

Stephane
