Return-Path: <linux-kernel-owner+w=401wt.eu-S1758780AbXEJLGa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758780AbXEJLGa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 07:06:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754113AbXEJLGY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 07:06:24 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34403 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbXEJLGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 07:06:23 -0400
Date: Thu, 10 May 2007 13:06:20 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Zhao Forrest <forrest.zhao@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, discuss@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: Re: [discuss] A question about GART aperture unmap
Message-ID: <20070510110620.GE15029@one.firstfloor.org>
References: <ac8af0be0705092259p65f057bcoe5e1b9abb963d5e3@mail.gmail.com> <20070510094908.GB14898@one.firstfloor.org> <ac8af0be0705100314p43a11d3cw10ce8e5726f9672c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac8af0be0705100314p43a11d3cw10ce8e5726f9672c@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Sorry, I missed the last sentence. This bug is reproduced by copying a
> large file(8G) and in the meanwhile compiling a linux kernel for about
> 1 to 2 days.

Ok that is then more expected. Don't know what causes the sync flood,
but data corruption is at least expected without the clear_kernel_mapping().
Just don't comment it out if you care about your data.

-Andi
