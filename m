Return-Path: <linux-kernel-owner+w=401wt.eu-S1753991AbZBJDLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991AbZBJDLT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 22:11:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752297AbZBJDLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 22:11:10 -0500
Received: from ozlabs.org ([203.10.76.45]:37022 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751698AbZBJDLJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 22:11:09 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 1/3] module: create a request_module_nowait()
Date: Tue, 10 Feb 2009 13:41:03 +1030
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: linux-kernel@vger.kernel.org, jkosina@suse.cz, mchehab@infradead.org
References: <20090208104201.6124ab6a@infradead.org> <200902091702.18887.rusty@rustcorp.com.au> <20090209072531.5cf92d3a@infradead.org>
In-Reply-To: <20090209072531.5cf92d3a@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902101341.04523.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 February 2009 01:55:31 Arjan van de Ven wrote:
> On Mon, 9 Feb 2009 17:02:17 +1030
> Rusty Russell <rusty@rustcorp.com.au> wrote:
> > Nice, applied.  Made one change; I've taken to using the new-fangled
> > bool type for flag args, for slight extra clarity.
> 
> for this case that's a bit unfortunate though.
> 
> the call usermode helper code takes 3 values, -1, 0 and 1.

Yes, we could re-use the umh enum if we want to change it.

Thanks,
Rusty.
