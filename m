Return-Path: <linux-kernel-owner+w=401wt.eu-S1754044AbZKCMUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044AbZKCMUe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 07:20:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752401AbZKCMUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 07:20:34 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:62718 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753901AbZKCMUd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 07:20:33 -0500
X-Greylist: delayed 744 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Nov 2009 07:19:32 EST
Date: Tue, 3 Nov 2009 13:05:03 +0100
From: Alessandro Rubini <rubini@gnudd.com>
To: cascardo@holoscopio.com
Cc: linux-kernel@vger.kernel.org, device@lanana.org, gregkh@suse.de
Subject: Re: [PATCH] misc: use a proper range for minor number dynamic
	allocation
Message-ID: <20091103120502.GA8304@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
X-Face: #Q;A)@_4.#>0+_%y]7aBr:c"ndLp&#+2?]J;lkse\^)FP^Lr5@O0{)J;'nny4%74.fM'
	n)M
	>ISCj.KmsL/HTxz!:Ju'pnj'Gz&.
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
In-Reply-To: <1256340497-19320-1-git-send-email-cascardo@holoscopio.com>
References: <1256340497-19320-1-git-send-email-cascardo@holoscopio.com> 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.
Please forgive my delay.

> First of all, the range for dynamic numbers include some statically
> allocated numbers. It goes from 63 to 0, and we have numbers in the
> range from 1 to 15 already allocated.

Yes, I wrote it ages ago. The "same as major numbers" testifies it.

I think your changes are sane, howver "git am" complains that
"patch doesn't apply". However, plain "patch -p1" liked it, so
I could test the result.

I think you need to rebase on current upstream, but apart from
that

Acked-By: Alessandro Rubini <rubini@vision.unipv.it>

/alessandro
